extends Control


var highScore = 0
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	VisualServer.set_default_clear_color(Color("04002d"))
	
	score = Global.score
	get_node("Score").text = str(score)
	get_node("Reason").text = Global.message
	loadHighScore()
	if (highScore < score):
		saveScore()
	pass # Replace with function body.


# call this at game end to store a new highscore
func saveScore():
	var f = File.new()
	f.open(Global.scoreFile, File.WRITE)
	f.store_string(str(score))
	f.close()
	print("saved")


func loadHighScore():
	var f = File.new()
	if f.file_exists(Global.scoreFile):
		f.open(Global.scoreFile, File.READ)
		var content = f.get_as_text()
		highScore = int(content)
		f.close()
		print(highScore)
		


func _on_Main_pressed() -> void:
	get_tree().change_scene("res://Menus/Mainmenu.tscn")
	pass # Replace with function body.
