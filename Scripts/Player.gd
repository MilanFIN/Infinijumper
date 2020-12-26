extends KinematicBody2D



const GRAVITY = 500
const JUMPPOWER = 300
const ATTACKDISTANCE = 30
const ATTACKDELAY = 300 #ms

var xDirection = 0
#stores the previous direction even if xdirection =0
var lastDirection = 1
var speedX = 100
var speedY = 0
var facingLeft = false

var damage = 1

var maxHp = 100
var hp = 0
var growDir = 1#temp


var lastAttackTime = 0




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp = 0.5*maxHp
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	
	if (hp < 0 or hp > maxHp):
		growDir *= -1
	hp += growDir
		

	
	speedY +=  GRAVITY*delta
	move_and_slide(Vector2(xDirection * speedX, speedY), Vector2.UP)
	if (is_on_floor()):
		speedY = 0




	get_node("Sprite").flip_h = facingLeft

	get_node("Attackray1").cast_to = Vector2(lastDirection*ATTACKDISTANCE, 0)
	get_node("Attackray2").cast_to = Vector2(lastDirection*ATTACKDISTANCE, -ATTACKDISTANCE)
	get_node("Attackray3").cast_to = Vector2(0, -ATTACKDISTANCE)
	
	xDirection = 0
func moveLeft():
	facingLeft = true
	lastDirection = -1
	xDirection = -1

func moveRight():
	facingLeft = false
	lastDirection = 1
	xDirection = 1

func jump():
	if (is_on_floor()):
		speedY = -JUMPPOWER

func attack():
	var currentTime = OS.get_ticks_msec()
	if (currentTime - lastAttackTime > ATTACKDELAY):
		for i in range(1,4):
			var target = get_node("Attackray"+str(i)).get_collider()
			if (target != null):
				target.interact(damage)
		lastAttackTime = currentTime


func pickup(type, amount):
	if (type == "hp"):
		hp += amount

