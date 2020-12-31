extends Node



var noise = OpenSimplexNoise.new()

func _ready() -> void:
	pass

func init():
	noise.octaves = 2
	noise.lacunarity = 2.0
	noise.period = 20.0#20.0
	noise.persistence = 0.5#0.8
	randomize()
	noise.seed = randi()


func generateTileheights(x, cols):

	var result = []
	for i in range(x, x+cols):
		result.push_back(int(noise.get_noise_1d(i) * 10))
		
	
	return result

