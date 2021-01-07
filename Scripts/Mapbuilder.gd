extends Node

#amount of map that has to exist in front of player or trigger regen
const MAPGENLEAD = 200 


const TREEPROBABILITY = 0.05
const MONSTERPROBABILITY = 0.1
const MONSTERTHRESHOLDS = [0.5, 1]

var generator = load("res://Scripts/Generator.gd").new()
#latest column that was completed
var lastTileX = 0
var yOffset = 15 #offset under player at startup
#first column of generated block
var firstTileX = 0

var mapHeightArray = []



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	generator.init()
	populateTilemap()


func _process(delta: float) -> void:
	var realLastTileX = get_node("TileMap").map_to_world(Vector2(lastTileX, 0)).x
	var playerX = get_parent().get_node("Player").position.x
	if (realLastTileX - playerX < MAPGENLEAD):#240
		populateTilemap()



func CreateDestroyables():
	var tilemap = get_node("TileMap")
	var j = 0
	for i in range(firstTileX, lastTileX):

		var probability = rand_range(0.0, 1.0)

		if (probability < TREEPROBABILITY):
			var y = mapHeightArray[j]
			var localC = Vector2(i, y)
			localC.y += yOffset
			localC.x += 1
			var globalC = tilemap.map_to_world(localC)

			var entityFile = load("res://Actors/Destroyables/Tree.tscn")
			var entity = entityFile.instance()
			entity.position = globalC

			get_parent().add_child(entity)
		j += 1
	pass


func CreateMonsters():
	var tilemap = get_node("TileMap")
	var j = 0
	for i in range(firstTileX, lastTileX):

		var probability = rand_range(0.0, 1.0)

		if (probability < MONSTERPROBABILITY):
			var y = mapHeightArray[j]
			var localC = Vector2(i, y)
			localC.y += yOffset
			localC.x += 1
			var globalC = tilemap.map_to_world(localC)

			var monsterType = rand_range(0.0, 1.0)
			var monsterName = ""
			if (monsterType < MONSTERTHRESHOLDS[0]):
				monsterName = "Spider"
			elif (monsterType < MONSTERTHRESHOLDS[1]):
				monsterName = "Orc"
			var monsterFile = load("res://Actors/Monsters/"+monsterName+".tscn")
			var monster = monsterFile.instance()
			monster.position = globalC
			get_parent().add_child(monster)
		j += 1
	pass


func setColumn(tilemap, x, height, biome):
	if (biome == "forest"):
		tilemap.set_cell(lastTileX, height, 1)
		var firstBelowSurface = height+1
		for filler in range(firstBelowSurface, firstBelowSurface + 22):
			tilemap.set_cell(lastTileX, filler, 0)
	if (biome == "desert"):
		tilemap.set_cell(lastTileX, height, 2)
		var firstBelowSurface = height+1
		for filler in range(firstBelowSurface, firstBelowSurface + 22):
			tilemap.set_cell(lastTileX, filler, 2)
	if (biome == "mountain"):
		if (height - yOffset < -3):
			tilemap.set_cell(lastTileX, height, 4)
		else:
			tilemap.set_cell(lastTileX, height, 3)
		var firstBelowSurface = height+1
		for filler in range(firstBelowSurface, firstBelowSurface + 22):
			tilemap.set_cell(lastTileX, filler, 3)
	if (biome == "swamp"):
		tilemap.set_cell(lastTileX, height, 5)
		var firstBelowSurface = height+1
		for filler in range(firstBelowSurface, firstBelowSurface + 22):
			tilemap.set_cell(lastTileX, filler, 5)
		var y = yOffset
		while (true):
			if (tilemap.get_cell(lastTileX, y) != -1):
				break
			tilemap.set_cell(lastTileX, y, 6)
			y += 1

func populateTilemap():

	firstTileX = lastTileX
	var tilemap = get_node("TileMap")
	var biome = generator.getBiome()
	mapHeightArray = generator.generateTileheights(lastTileX, 27)

	print(biome)

	#first iteration, so should ensure that ground is under player
	if (tilemap.get_used_cells().size() == 0):
		var tile = tilemap.world_to_map(get_parent().get_node("Player").position)
		yOffset = yOffset- mapHeightArray[tile.x]


	for x in range(len(mapHeightArray)):
		setColumn(tilemap, lastTileX, mapHeightArray[x]+yOffset, biome)

		lastTileX += 1


	#TODO: FIX BY USING GET_USED_CELLS, and remove from those instead
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
	
	
	#add trees etc
	CreateDestroyables()
	CreateMonsters()
	
