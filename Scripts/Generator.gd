extends Node



var noise = OpenSimplexNoise.new()
var multiplier = 10


var biomeArray = ["forest", "mountain", "desert"]


#TODO: only call mapbuilder when the last x tile reaches edge of screen
#TODO: look at linear interpolation for transitions between biomes

var nextBiome = ""
var biome = ""
var lastBiome = ""
var lastHeight = 0
var nextHeight = 0


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
	setBiome("forest")
	lastBiome = "forest"
	biome = "forest"

#returns the biome that is generated  by the next generateTileHeights call
func getBiome():
	return biome

#generates new heightmap and changes biome
func generateTileheights(x, cols):
	var result = []
	nextBiome = biomeArray[randi() % biomeArray.size()]
	setBiome(nextBiome)
	nextHeight = int(noise.get_noise_1d(x+cols-1) * multiplier)
	setBiome(biome)

	for i in range(x, x+cols):
		var val = 0
		#must interpolate at beginning of each biome if next is different
		if (i < x+5 and biome != lastBiome):
			var unintVal = int(noise.get_noise_1d(i) * multiplier)
			if (i < x+1):
				val = (lastHeight*5 +unintVal*1) / 6
			elif (i < x+2):
				val = (lastHeight*4 +unintVal*2) / 6
			elif (i < x+3):
				val = (lastHeight*3 +unintVal*3) / 6
			elif (i < x+4):
				val = (lastHeight*2 +unintVal*4) / 6
			elif (i < x+5):
				val = (lastHeight*1 +unintVal*5) / 6
		#must interpolate at end of each biome, if next is different
		elif (i >= x+cols-5 and biome != nextBiome):
			var unintVal = int(noise.get_noise_1d(i) * multiplier)
			if (i < x+cols-4):
				val = (nextHeight*1 +unintVal*5) / 6
			elif (i < x+cols -3):
				val = (nextHeight*2 +unintVal*4) / 6
			elif (i < x+cols - 2):
				val = (nextHeight*3 +unintVal*3) / 6
			elif (i < x+cols - 1):
				val = (nextHeight*4 +unintVal*2) / 6
			elif (i < x+cols -0):
				val = (nextHeight*5 +unintVal*1) / 6
		else:
			val = int(noise.get_noise_1d(i) * multiplier)

		result.push_back(val)
		
		#must store last value as lastheight
		if (i == x+cols -1):
			lastHeight = val

	lastBiome = biome
	biome = nextBiome
	nextBiome = biomeArray[randi() % biomeArray.size()]
	setBiome(biome)

	return result





#OLD, EXISTS AS A BACKUP IF SOMETHING BREAKS WITH INTERPOLATION
var started = false
var lastY = 0
var offset = 0
func generateTileHeights_old(x, cols):

	var result = []
	var firstVal = int(noise.get_noise_1d(x) * multiplier+offset)
	if (started and abs(firstVal - lastY) > 1):
		offset += lastY - firstVal
	for i in range(x, x+cols):
		var val = int(noise.get_noise_1d(i) * multiplier + offset)

		result.push_back(val)
		if (i == x+cols-1):
			lastY = val
			started = true
	var biome = biomeArray[randi() % biomeArray.size()]
	setBiome(biome)
	return result
