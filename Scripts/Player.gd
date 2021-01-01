extends KinematicBody2D



const GRAVITY = 500
const JUMPPOWER = 300
const ATTACKDISTANCE = 25
const ATTACKDELAY = 300 #ms

var slashFile = load("res://Actors/Effects/Slash.tscn")



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

	



func _physics_process(delta: float) -> void:
	
	#if (hp < 0 or hp > maxHp):
	#	growDir *= -1
	#hp += growDir


	
	speedY +=  GRAVITY*delta
	move_and_slide(Vector2(xDirection * speedX, speedY), Vector2.UP)
	if (is_on_floor()):
		speedY = 0

	get_node("Attackray1").cast_to = Vector2(lastDirection*ATTACKDISTANCE, 0)
	get_node("Attackray2").cast_to = Vector2(lastDirection*ATTACKDISTANCE, -ATTACKDISTANCE)
	get_node("Attackray3").cast_to = Vector2(0, -ATTACKDISTANCE)
	get_node("Attackray4").cast_to = Vector2(lastDirection*ATTACKDISTANCE, ATTACKDISTANCE)
	get_node("Attackray5").cast_to = Vector2(0, ATTACKDISTANCE)
	


	get_node("Sprite").flip_h = facingLeft

	#animations
	#attacking

	if (OS.get_ticks_msec() - lastAttackTime < ATTACKDELAY):
		get_node("Sprite").play("attack")
	elif (speedY == 0):#on the ground
		if (xDirection == 0 ): #idle
			get_node("Sprite").play("idle")
		elif (xDirection != 0): #running
			get_node("Sprite").play("run")
	elif (speedY > 0):#in air
		get_node("Sprite").play("fall")
	elif (speedY < 0):
		get_node("Sprite").play("jump")
	
	xDirection = 0


func moveLeft(amount):
	facingLeft = true
	lastDirection = -1
	xDirection = -amount

func moveRight(amount):
	facingLeft = false
	lastDirection = 1
	xDirection = amount

func jump():
	if (is_on_floor()):
		speedY = -JUMPPOWER

func attack():
	var currentTime = OS.get_ticks_msec()
	if (currentTime - lastAttackTime > ATTACKDELAY):
		for i in range(1,6):
			var target = get_node("Attackray"+str(i)).get_collider()
			if (target != null):
				target.interact(damage)

		var slash = slashFile.instance()
		#TODO: add as child and set position & dir
		slash.setDir(lastDirection)
		slash.position = get_node("Attackray1").cast_to*0.5
		add_child(slash)
		lastAttackTime = currentTime



func pickup(type, amount):
	if (type == "hp"):
		hp += amount
		if (hp > maxHp):
			hp = maxHp

func hurt(damage):
	hp -= damage
