extends Node

#amount of map that has to exist in front of player or trigger regen
const MAPGENLEAD = 420 


const TREEPROBABILITY = 0.1
const MONSTERPROBABILITY = 0.1
const MONSTERTHRESHOLDS = [0.33, 0.66, 1]


var generator = load("res://Scripts/Generator.gd").new()
#latest column that was completed
var lastTileX = 0
var yOffset = 16 #offset under player at startup
#first column of generated block
var firstTileX = 0

var mapHeightArray = []


var movedX = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	generator.init()
	populateTilemap()




func playerProcess(player):
	var realLastTileX = get_node("TileMap").map_to_world(Vector2(lastTileX, 0)).x
	#realLastTileX += 

	var playerX = get_parent().get_node("Player").position.x
	if (realLastTileX - playerX < MAPGENLEAD):#240
		populateTilemap()
		



func CreateDestroyables(biome):
	var tilemap = get_node("TileMap")
	var j = 0
	for i in range(firstTileX, lastTileX):

		var probability = rand_range(0.0, 1.0)


		if (probability < TREEPROBABILITY):
			
			var y = mapHeightArray[j]
			var localC = Vector2(i, y)
			localC.y += yOffset
			var globalC = tilemap.map_to_world(localC)
			var entityType = rand_range(0.0, 1.0)

			var entityName = ""
			if (biome == "swamp"):
				entityName = "Moss"
			elif (biome == "forest"):
				entityName = "Tree"
			elif (biome == "desert"):
				entityName = "Cactus"
			elif (biome == "lake"):
				entityName = "Seaweed"
			elif (biome == "mountain"):
				entityName = "Twig"
			var entityFile = load("res://Actors/Destroyables/"+entityName+".tscn")
			var entity = entityFile.instance()
			entity.position = globalC
			entity.position.x += 8

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
			var globalC = tilemap.map_to_world(localC)

			var monsterType = rand_range(0.0, 1.0)
			var monsterName = ""
			if (monsterType < MONSTERTHRESHOLDS[0]):
				monsterName = "Ghost"
			elif (monsterType < MONSTERTHRESHOLDS[1]):
				monsterName = "Spider"
			elif (monsterType < MONSTERTHRESHOLDS[2]):
				monsterName = "Orc"
			var monsterFile = load("res://Actors/Monsters/"+monsterName+".tscn")
			var monster = monsterFile.instance()
			monster.position = globalC
			monster.position.x += 8
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
		for filler in range(firstBelowSurface, firstBelowSurface + 30):
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
	if (biome == "lake"):
		tilemap.set_cell(lastTileX, height, 2)
		var firstBelowSurface = height+1
		for filler in range(firstBelowSurface, firstBelowSurface + 22):
			tilemap.set_cell(lastTileX, filler, 2)
		var y = yOffset
		while (true):
			if (tilemap.get_cell(lastTileX, y) != -1):
				break
			tilemap.set_cell(lastTileX, y, 6)
			y += 1

func clearPastTiles():
	var tilemap = get_node("TileMap")
	var cameraLeftPoint = get_parent().get_node("Cameramount").position
	cameraLeftPoint.x -= 320
	var lastVisiblePoint = tilemap.world_to_map(cameraLeftPoint)
	var allVisibleTiles = tilemap.get_used_cells()

	for i in allVisibleTiles:
		if (i.x < lastVisiblePoint.x):
			tilemap.set_cell(i.x, i.y, -1)

func createTiles():
	firstTileX = lastTileX
	var tilemap = get_node("TileMap")
	var biome = generator.getBiome()
	mapHeightArray = generator.generateTileheights(lastTileX, 27)



	#first iteration, so should ensure that ground is under player
	if (tilemap.get_used_cells().size() == 0):
		var tile = tilemap.world_to_map(get_parent().get_node("Player").position)
		#yOffset =  yOffset - mapHeightArray[tile.x] + 
		
		yOffset = yOffset - get_parent().get_node("Player").position.y/16 - mapHeightArray[tile.x]
		

	for x in range(len(mapHeightArray)):
		setColumn(tilemap, lastTileX, mapHeightArray[x]+yOffset, biome)

		lastTileX += 1

	return biome

func populateTilemap():

	var biome = createTiles()
	clearPastTiles()
	#add trees etc
	CreateDestroyables(biome)
	CreateMonsters()
	
