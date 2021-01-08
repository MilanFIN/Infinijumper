extends StaticBody2D

export var hp = 1
export var drop = ""
export var deathEffect = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if (hp <= 0):
		if (drop != ""):

			var dropFile = load("res://Actors/Drops/"+drop+".tscn")
			var dropInstance = dropFile.instance()
			dropInstance.position = position

			get_parent().add_child(dropInstance)

		if (deathEffect != ""):
				var deathFile = load("res://Actors/Effects/"+deathEffect+".tscn")
				var deathAnimation = deathFile.instance()
				deathAnimation.position = position

				get_parent().add_child(deathAnimation)
		queue_free()

func interact(dmg):
	hp -= dmg
	

