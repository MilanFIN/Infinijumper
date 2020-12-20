extends KinematicBody2D


const GRAVITY = 100

var speedY = -100
var speedX


var timeSpentInDirection = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speedX = rand_range(-100, 100)
	#speedX = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	speedY += delta*GRAVITY
	move_and_slide(Vector2(speedX, speedY))
	if (is_on_floor()):
		speedY = 0


	timeSpentInDirection += delta

	if (timeSpentInDirection > 2):
		speedX *= -1
		timeSpentInDirection = 0




func interact(dmg):
	queue_free()
