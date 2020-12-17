extends Node



var generator = load("res://Scripts/Generator.gd").new()
var lastTileX = 0
var yOffset = 15 #offset under player at startup


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generator.init()
	populateTilemap()


func _process(delta: float) -> void:
	var realLastTileX = get_node("TileMap").map_to_world(Vector2(lastTileX, 0)).x
	var playerX = get_parent().get_node("Player").position.x
	if (realLastTileX - playerX < 320):
		populateTilemap()
		print("populating")



func populateTilemap():

	var tilemap = get_node("TileMap")
	#tilemap.clear()
	var mapArray = generator.generateTileheights(lastTileX, 40)
	#first iteration, so should ensure that ground is under player
	if (tilemap.get_used_cells().size() == 0):
		var tile = tilemap.world_to_map(get_parent().get_node("Player").position)
		yOffset = yOffset- mapArray[tile.x]



	print(mapArray.size())
	for x in range(len(mapArray)):
		lastTileX += 1
		tilemap.set_cell(lastTileX, mapArray[x]+yOffset, 1)
		var firstBelowSurface = mapArray[x]+yOffset+1
		for filler in range(firstBelowSurface, firstBelowSurface + 22):
			tilemap.set_cell(lastTileX, filler, 0)




	#using currentTileY remove everything from screen point 0 backwards
	var cameraLeftPoint = get_parent().get_node("Cameramount").position
	cameraLeftPoint.x -= 320
	var lastVisiblePoint = tilemap.world_to_map(cameraLeftPoint)
	#should be removing the first invinsible one
	lastVisiblePoint.x -= 1
	lastVisiblePoint.y = yOffset
	for i in range(0, 100):#45 might be enough
		for j in range(0, 100):
			tilemap.set_cell(lastVisiblePoint.x - i, j, -1)
			tilemap.set_cell(lastVisiblePoint.x -i, -j, -1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
