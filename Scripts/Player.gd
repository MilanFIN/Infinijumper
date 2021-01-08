extends Actor




var JUMPPOWER = 300
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
var maxArmor = 100
var armor = 0



var lastAttackTime = 0




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp = 0.5*maxHp
	armor = 0.5*maxArmor

	



func _physics_process(delta: float) -> void:

	var gravity = GRAVITY
	if (inWater()):
		gravity *= 0.1


	speedY +=  gravity*delta
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
	elif (type == "armor"):
		armor += amount
		if (armor > maxArmor):
			armor = maxArmor


func hurt(damage):
	#quake 3 style armor depleting, should work
	var armorDamage = 2*damage/3.0
	if (armor >= armorDamage):
		armor -= armorDamage
		hp -= damage/3.0
	#if not enough armor, reduce the damage by 3/2*amount of armor left
	#also works if armor == 0
	elif (armor < armorDamage):
		damage -= 1.5 * armor
		hp -= damage
		armor = 0

	if (armor < 0):
		armor = 0
