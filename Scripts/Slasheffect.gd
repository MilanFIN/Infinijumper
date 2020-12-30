extends Sprite


var lifeTime = 0.25 #seconds


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifeTime -= delta
	if (lifeTime < 0):
		queue_free()

func setDir(dir):
	if (dir < 0):
		flip_h = true
