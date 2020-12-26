extends KinematicBody2D


const GRAVITY = 500
const JUMPPOWER = 150

var speedY = -100
var speedX

var dirX = 1
var timeSpentInDirection = 0
var maxTimeUntilDirChange = 2
var minTimeUntilDirChange = 0.5

var aggressive = false

var blockCastDistanceX = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speedX = rand_range(0, 70)
	#speedX = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	var previousDir = dirX
	
	speedY += delta*GRAVITY

	move_and_slide(Vector2(speedX*dirX, speedY), Vector2.UP)

	if (is_on_floor()):
		speedY = 0

		var blockage = get_node("Blockageray").get_collider()
		
		if (blockage != null):
			if (blockage.name == "TileMap"): #colliding with environment
				speedY = -JUMPPOWER

	timeSpentInDirection += delta

	if (not aggressive):
		if (timeSpentInDirection > maxTimeUntilDirChange):
			dirX *= -1



	var playerX = get_tree().get_root().get_node("Game/Player").position.x
	if (abs(position.x - playerX) < 100):
		aggressive = true
	else:
		aggressive = false

	if (aggressive and timeSpentInDirection > minTimeUntilDirChange):
		if (playerX < position.x):
			dirX = -1
		else:
			dirX = 1
		
	get_node("Blockageray").cast_to = Vector2(blockCastDistanceX*dirX, 0)

	if (dirX > 0):
		get_node("Sprite").flip_h = true
	else:
		get_node("Sprite").flip_h = false

	if (dirX != previousDir):
		timeSpentInDirection = 0

func interact(dmg):
	queue_free()
