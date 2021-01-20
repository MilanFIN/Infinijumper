extends KinematicBody2D
class_name Actor

const GRAVITY = 500
const WATERTOPSPEED = 100
var speedY = 0
var speedX = 0
var xDirection = 0


var speedMultiplier = 1.0
var attackMultiplier = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func move(delta):
	var gravity = GRAVITY
	if (inWater()):
		gravity *= 0.1
		speedY = clamp(speedY, -WATERTOPSPEED, WATERTOPSPEED)


	speedY +=  gravity*delta
	move_and_slide(Vector2(xDirection * speedX*speedMultiplier, speedY), Vector2.UP)
	if (is_on_floor()):
		speedY = 0

func inWater():
	var tilemap = get_parent().get_node("Mapbuilder/TileMap")
	#var tilemap = get_tree().get_root().get_node("Game/Mapbuilder/TileMap")
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
