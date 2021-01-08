extends KinematicBody2D
class_name Actor

const GRAVITY = 500


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func inWater():
	var tilemap = get_tree().get_root().get_node("Game/Mapbuilder/TileMap")
	var footPosition = get_node("Feet").get_global_position()

	var tilemapPos = tilemap.world_to_map(footPosition)
	if (tilemap.get_cell(tilemapPos.x, tilemapPos.y) != -1):
		#we are in a tile, so probably in water
		return true
	else:
		return false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
