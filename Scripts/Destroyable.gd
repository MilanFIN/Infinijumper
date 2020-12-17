extends StaticBody2D

export var hp = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if (hp <= 0):
		queue_free()

func interact(dmg):
	hp -= dmg
	
