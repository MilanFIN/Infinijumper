extends Node2D


var direction = -1
const transitionSpeed = 0.1 #change speed between dark and bright
var timeAtEnd = 0.0
const endDuration = 5.0 #time spent in complete dark or bright between changes 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	print(get_node("Day").color.a)

func _process(delta: float) -> void:
	var lightAmount = get_node("Day").color.a
	lightAmount += direction * delta * transitionSpeed
	
	
	lightAmount = clamp(lightAmount, 0.0, 1.0)
	if (lightAmount == 0.0 or lightAmount == 1.0):
		timeAtEnd += delta

	if (timeAtEnd > endDuration):
		direction = direction*-1
		timeAtEnd = 0.0
	get_node("Day").color.a = lightAmount
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
