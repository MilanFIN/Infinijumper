extends Actor



export var type = ""
export var amount = 0




# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	var directions = [-1, 1]
	xDirection = directions[randi() % directions.size()]
	speedX = rand_range(0, 100)
	speedY = -100



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (not is_on_floor()):
		move(delta)

	if (is_on_wall() and not(is_on_floor())):
		xDirection *= -1




func _on_Apple_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		body.pickup(type, amount)
		queue_free()

