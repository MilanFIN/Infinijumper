extends Node2D


const MOVESPEED = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta):
	get_node("Player").position.x += delta*MOVESPEED


	get_node("Mapbuilder").playerProcess(get_node("Player"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
