extends Node2D


const MOVESPEED = 20
const PLAYERYOFFSET = 48
var score = 0
var highScore = 0

var previousValues = []
var lengthOfRollingAvg = 20





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loadHighScore()
	
	get_node("Hud/Score").text = str(highScore)
	pass # Replace with function body.

func _process(delta):
	var player = get_node("Player")
	var tilemap = get_node("Mapbuilder/TileMap")
	player.position.x += delta*MOVESPEED

	var posInTilemap = tilemap.world_to_map(player.position)

	var newY = 0

	if (tilemap.get_cell(posInTilemap.x, posInTilemap.y) == -1):
		for i in range(posInTilemap.y, posInTilemap.y+50):
			if (tilemap.get_cell(posInTilemap.x, i) != -1):
				newY = i
				break
	else:
		for i in range(posInTilemap.y, posInTilemap.y-50):
			if (tilemap.get_cell(posInTilemap.x, i) == -1):
				break
			newY = i

	previousValues.append(newY)
	if (previousValues.size() > lengthOfRollingAvg):
		previousValues = previousValues.slice(previousValues.size()-lengthOfRollingAvg, previousValues.size())
	
	var averageY = 0
	for i in previousValues:
		averageY += i
	averageY /= lengthOfRollingAvg
	


	player.position.y = tilemap.map_to_world(Vector2(posInTilemap.x, averageY)).y - PLAYERYOFFSET
	get_node("Mapbuilder").playerProcess(player)


func loadHighScore():
	var f = File.new()
	if f.file_exists(Global.scoreFile):
		f.open(Global.scoreFile, File.READ)
		var content = f.get_as_text()
		highScore = int(content)
		f.close()
