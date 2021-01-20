extends Actor



const JUMPPOWER = 150
const hurtAnimationTime = 0.15 #seconds
const attackAnimationTime = 0.15 #seconds

export var damage = 3
export var attackDelay = 1000
export var attackDistance = 20
export var hp = 2
export var speed = 50
export var deathEffect = ""
export var drop = ""




var timeSpentInDirection = 0
var maxTimeUntilDirChange = 2
var minTimeUntilDirChange = 0.5

var aggressive = false

var blockCastDistanceX = 20

var lastAttackTime = 0

var tookDamage = false #took damage this game tick?
var timeSinceHurt = 99999
var timeSinceAttack = 99999

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speedX = speed
	speedY = -100
	xDirection = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	var previousDir = xDirection
	
	move(delta)

	if (is_on_floor()):

		var blockage = get_node("Blockageray").get_collider()
		
		if (blockage != null):
			if (blockage.name == "TileMap"): #colliding with environment
				speedY = -JUMPPOWER

	timeSpentInDirection += delta

	if (not aggressive):
		if (timeSpentInDirection > maxTimeUntilDirChange):
			xDirection *= -1

	var player = get_parent().get_node("Player")


		#var playerX = get_tree().get_root().get_node("Game/Player").position.x
	
	var playerX = get_parent().get_node("Player").position.x
	if (abs(position.x - playerX) < 100 and player is Actor):
		aggressive = true
	else:
		aggressive = false

	if (aggressive and timeSpentInDirection > minTimeUntilDirChange):
		if (playerX < position.x):
			xDirection = -1
		else:
			xDirection = 1
		
	get_node("Blockageray").cast_to = Vector2(blockCastDistanceX*xDirection, 0)


	if (xDirection != previousDir):
		timeSpentInDirection = 0


	if (not aggressive):
		if (xDirection > 0):
			get_node("Sprite").flip_h = false
		else:
			get_node("Sprite").flip_h = true
	else:
		if (position.x > playerX):
			get_node("Sprite").flip_h = true
		else:
			get_node("Sprite").flip_h = false


	if (aggressive):
		#var playerPos = get_tree().get_root().get_node("Game/Player").position
		var playerPos = get_parent().get_node("Player").position
		if ((playerPos - position).length() < attackDistance):
			var currentTime = OS.get_ticks_msec()
			if (currentTime - lastAttackTime > attackDelay):
				attack()



	#animations
	if (timeSinceAttack < attackAnimationTime):
		timeSinceAttack += delta
		get_node("Sprite").play("attack")
	elif (timeSinceHurt < hurtAnimationTime):
		timeSinceHurt += delta
		get_node("Sprite").play("hurt")
	else:
		get_node("Sprite").play("run")



	tookDamage = false
	
	

	speedMultiplier = get_parent().score / 300.0
	if (speedMultiplier < 1.0):
		speedMultiplier = 1.0
	attackMultiplier = get_parent().score / 75.0
	if (attackMultiplier < 1.0):
		attackMultiplier = 1.0


func attack():
	var dmg = damage * attackMultiplier
	get_tree().get_root().get_node("Game/Player").hurt(dmg)
	lastAttackTime = OS.get_ticks_msec()
	timeSinceAttack = 0


func interact(dmg):
	if (not tookDamage):
		tookDamage = true
		hp -= dmg
		timeSinceHurt = 0

		if (hp <= 0):
			if (deathEffect != ""):
				var deathFile = load("res://Actors/Effects/"+deathEffect+".tscn")
				var deathAnimation = deathFile.instance()
				deathAnimation.position = position
				if (get_node("Sprite").flip_h):
					deathAnimation.flip()
				get_parent().add_child(deathAnimation)


			if (drop != ""):

				var dropFile = load("res://Actors/Drops/"+drop+".tscn")
				var dropInstance = dropFile.instance()
				dropInstance.position = position

				get_parent().add_child(dropInstance)
			queue_free()
