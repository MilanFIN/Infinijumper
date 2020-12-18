extends Area2D

export var type = ""
export var amount = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass





func _on_Apple_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		body.pickup(type, amount)
		queue_free()

