extends StaticBody2D

export var hp = 1
export var drop = ""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if (hp <= 0):
		if (drop != ""):
			print("should drop something")
			var dropFile = load("res://Actors/Drops/"+drop+".tscn")
			var dropInstance = dropFile.instance()
			dropInstance.position = position

			get_parent().add_child(dropInstance)

		queue_free()

func interact(dmg):
	hp -= dmg
	

