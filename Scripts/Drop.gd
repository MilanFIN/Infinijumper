extends Actor



export var type = ""
export var amount = 0

var speedY = -100
var speedX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speedX = rand_range(-100, 100)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(not is_on_floor()):
		var gravity = GRAVITY
		if (inWater()):
			gravity *= 0.1
		speedY += delta*gravity
		move_and_slide(Vector2(speedX, speedY), Vector2.UP)

	if (is_on_wall() and not(is_on_floor())):
		speedX *= -1




func _on_Apple_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		body.pickup(type, amount)
		queue_free()

