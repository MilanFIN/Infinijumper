extends Node2D


const MAXJOYSTICKMOVEMENT = 30

const SCOREDIVIDER = 32

var startX = 0
var lastX
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	startX = int(get_node("Player").position.x)
	lastX = startX

func _process(delta: float) -> void:
	if (Input.is_action_pressed("left")):
		get_node("Player").moveLeft(1)
	if (Input.is_action_pressed("right")):
		get_node("Player").moveRight(1)
	if (Input.is_action_just_pressed("jump")):
		get_node("Player").jump()
	if (Input.is_action_just_pressed("attack")):
		get_node("Player").attack()

	#handle joystick
	var basePos = get_node("Hud/Base").position.x
	var stickPos = get_node("Hud/Stick").position.x
	var dir = (stickPos - basePos) / MAXJOYSTICKMOVEMENT

	if (dir < 0):
		get_node("Player").moveLeft(abs(dir))
	if (dir > 0):
		get_node("Player").moveRight(abs(dir))

	#update hud
	var hp = get_node("Player").hp
	var maxHp = get_node("Player").maxHp
	get_node("Hud/Healthbar").setHp(hp, maxHp)
	var armor = get_node("Player").armor
	var maxArmor = get_node("Player").maxArmor
	get_node("Hud/Armorbar").setHp(armor, maxArmor)
	if (get_node("Player").submerged()):
		var air = get_node("Player").air
		var maxAir = get_node("Player").maxAir
		get_node("Hud/Airbar").setHp(air, maxAir)
	else:
		get_node("Hud/Airbar").setHp(0, 1)
	
	if (int(get_node("Player").position.x) > lastX):
		lastX = int(get_node("Player").position.x)

	
	score = (lastX - startX)/SCOREDIVIDER
	get_node("Hud/Score").setScore(score)


	if (get_node("Player").hp <= 0):
		Global.score = score
		get_tree().change_scene("res://Menus/Endscreen.tscn")

func _input(event):
	#this is all joystick related stuff
	var directionalInput = false
	if event is InputEventScreenTouch:
		if event.is_pressed():
			directionalInput = true
		else: 
			directionalInput = false
	if event is InputEventScreenDrag: 
		directionalInput = true
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if (abs(get_node("Hud/Base").position.y - (event.position.y - 120)) > 60):
				directionalInput = false
		if (abs(get_node("Hud/Base").position.x - (event.position.x - 210)) > 80):
				directionalInput = false
		if (not directionalInput and event.position.x < 210):
			get_node("Hud/Stick").position = get_node("Hud/Base").position
		elif (directionalInput):
			#finally can be sure that should record movement input
			var stickPosition = event.position.x -210
			stickPosition = clamp(stickPosition, get_node("Hud/Base").position.x-MAXJOYSTICKMOVEMENT, get_node("Hud/Base").position.x+MAXJOYSTICKMOVEMENT)
			get_node("Hud/Stick").position.x = stickPosition

	if event is InputEventMouseButton:
		if event.is_pressed():
			var absdiff = abs(get_node("Hud/Base").position.x - (event.position.x - 210))
			print(absdiff)
#func _draw():
#	draw_line(Vector2(0,0), Vector2(50, 50), Color(255, 0, 0), 1)

