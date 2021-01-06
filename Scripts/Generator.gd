extends Node



var noise = OpenSimplexNoise.new()
var multiplier = 10

var started = false
var lastY = 0

var offset = 0


func _ready() -> void:
	pass

func setBiome(biome):
	if (biome == "forest"):
		multiplier = 10
		noise.octaves = 2#2
		noise.lacunarity = 2.0
		noise.period = 20.0#20.0
		noise.persistence = 0.5
	elif (biome == "mountain"):
		multiplier = 20
		noise.octaves = 2#2
		noise.lacunarity = 2.0
		noise.period = 20.0#20.0
		noise.persistence = 0.5
	elif (biome == "desert"):
		multiplier = 10
		noise.octaves = 2#2
		noise.lacunarity = 2.0
		noise.period = 64
		noise.persistence = 0.5


func init():
	#noise.octaves = 2#2
	#noise.lacunarity = 2
	#noise.period = 20#20.0#20.0
	#noise.persistence = 0.5
	randomize()
	noise.seed = randi()
	setBiome("desert")

func generateTileheights(x, cols):

	var result = []
	
	var firstVal = int(noise.get_noise_1d(x) * multiplier)
	if (started and abs(firstVal - lastY) > 1):
		offset = (lastY - firstVal)
	
	for i in range(x, x+cols):
		var val = int(noise.get_noise_1d(i) * multiplier + offset)

		result.push_back(val)
		if (i == x+cols-1):
			lastY = val
			started = true
	

	var my_array = ["forest", "mountain", "desert"]
	var biome = my_array[randi() % my_array.size()]
	print(biome)
	setBiome(biome)
	return result

