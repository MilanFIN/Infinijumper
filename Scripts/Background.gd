extends Node2D


#previous background : 01000c
const transitionDuration = 10#5 #time between light and dark
const endDuration = 30#5 #time spent in complete dark or bright between changes 

var direction = -1
var timeAtEnd = 0.0

var transitionTime = 0.0 #time from the last afternoon onwards



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	get_node("Moon").position.y = -100

func _process(delta: float) -> void:
	var lightAmount = get_node("Day").color.a
	lightAmount += direction * delta / transitionDuration

	
	lightAmount = clamp(lightAmount, 0.0, 1.0)
	if (lightAmount == 0.0 or lightAmount == 1.0):
		timeAtEnd += delta

	transitionTime += delta



	if (timeAtEnd > endDuration):
		direction *= -1
		timeAtEnd = 0.0
		if (lightAmount == 1):
			transitionTime = 0.0

	var amount = (transitionTime ) / (transitionDuration*2 + endDuration)
	get_node("Moon").position.x = -200 + 400*amount

	

	get_node("Day").color.a = lightAmount


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
