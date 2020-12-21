extends KinematicBody2D


const GRAVITY = 100

var speedY = -100
var speedX

var dirX = 1
var timeSpentInDirection = 0

var aggressive = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speedX = rand_range(100, 100)
	#speedX = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	speedY += delta*GRAVITY
	move_and_slide(Vector2(speedX*dirX, speedY))
	if (is_on_floor()):
		speedY = 0


	timeSpentInDirection += delta

	if (not aggressive):
		if (timeSpentInDirection > 2):
			dirX *= -1
			timeSpentInDirection = 0

	var playerX = get_tree().get_root().get_node("Game/Player").position.x
	if (abs(position.x - playerX) < 100):
		aggressive = true
	else:
		aggressive = false

	if (aggressive):
		if (playerX < position.x):
			dirX = -1
		else:
			dirX = 1

func interact(dmg):
	queue_free()
