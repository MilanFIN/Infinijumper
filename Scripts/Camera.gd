extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	var player = get_parent().get_parent().get_node("Player")
	var pos = get_parent().position
	var velocity = Vector2(0,0)
	if (abs(pos.x - player.position.x) < 30):
		velocity.y =  (player.position.y - pos.y) * 0.7
	else:
		velocity = (player.position - pos) * 0.7
		#prevent camera from moving backwards
		velocity.x = clamp(velocity.x, 0, 100)

	get_parent().move_and_slide(velocity, Vector2.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
