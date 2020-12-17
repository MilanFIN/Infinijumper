extends Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_Start_pressed() -> void:
	Global.mode = "single"
	get_tree().change_scene("res://Game.tscn")
	pass # Replace with function body.
