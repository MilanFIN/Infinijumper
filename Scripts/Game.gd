extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if (Input.is_action_pressed("left")):
		get_node("Player").moveLeft()
	if (Input.is_action_pressed("right")):
		get_node("Player").moveRight()
	if (Input.is_action_just_pressed("jump")):
		get_node("Player").jump()
	if (Input.is_action_just_pressed("attack")):
		get_node("Player").attack()

	#handle joystick
	if (get_node("CanvasLayer/Stick").position.x < get_node("CanvasLayer/Base").position.x):
		get_node("Player").moveLeft()
	if (get_node("CanvasLayer/Stick").position.x > get_node("CanvasLayer/Base").position.x):
		get_node("Player").moveRight()






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
		if (abs(get_node("CanvasLayer/Base").position.y - (event.position.y - 180)) > 40):
				directionalInput = false
		if (abs(get_node("CanvasLayer/Base").position.x - (event.position.x - 320)) > 100):
				directionalInput = false
		if (not directionalInput and event.position.x < 320):
			get_node("CanvasLayer/Stick").position = get_node("CanvasLayer/Base").position
		elif (directionalInput):
			#finally can be sure that should record movement input
			get_node("CanvasLayer/Stick").position.x = event.position.x - 320

	if event is InputEventMouseButton:
		if event.is_pressed():
			print(abs(get_node("CanvasLayer/Base").position.x - (event.position.x - 320)))
#func _draw():
#	draw_line(Vector2(0,0), Vector2(50, 50), Color(255, 0, 0), 1)

