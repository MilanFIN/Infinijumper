extends Node



var noise = OpenSimplexNoise.new()
var valleyMultiplier = 10
var hillMultiplier = 10
var floorLevel = 0 # float from -1 to 1, -1 is high, 1 low


var biomeArray = ["forest", "mountain", "desert", "swamp", "lake"]

var biomeTransitions = {
	"forest": [[0.25,"forest"], [0.50,"mountain"], [0.65,"desert"], [0.80,"swamp"], [1.0, "lake"]],
	"mountain": [[0.5, "mountain"], [1.0,"forest"]],
	"desert": [[0.4, "desert"], [0.70, "forest"] ,[1.0,"lake"]],
	"swamp": [[0.5, "swamp"], [1.0, "forest"]],
	"lake": [[0.3, "lake"], [0.65, "forest"], [1.0, "desert"]]
}

#TODO: only call mapbuilder when the last x tile reaches edge of screen
#TODO: look at linear interpolation for transitions between biomes

var nextBiome = ""
var biome = ""
var lastBiome = ""
var lastHeight = 0
var nextHeight = 0


func _ready() -> void:
	pass



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

func setBiome(biome):
	if (biome == "forest"):
		hillMultiplier = 7
		valleyMultiplier = 7
		floorLevel = -0.5
		noise.octaves = 2#2
		noise.lacunarity = 2.0
		noise.period = 20.0#20.0
		noise.persistence = 0.5
	elif (biome == "mountain"):
		hillMultiplier = 15
		valleyMultiplier = 0
		floorLevel = -1.0
		noise.octaves = 2#2
		noise.lacunarity = 2.0
		noise.period = 20.0#20.0
		noise.persistence = 0.5

	elif (biome == "desert"):
		hillMultiplier = 5
		valleyMultiplier = 5
		floorLevel = -0.5
		noise.octaves = 2#2
		noise.lacunarity = 2.0
		noise.period = 64
		noise.persistence = 0.5
	elif (biome == "swamp"):
		hillMultiplier = 2
		valleyMultiplier = 4
		floorLevel = 0.0
		noise.octaves = 2#2
		noise.lacunarity = 2.0
		noise.period = 5
		noise.persistence = 0.5
	elif (biome == "lake"):
		hillMultiplier = 0
		valleyMultiplier = 3
		floorLevel = 1.0
		noise.octaves = 2#2
		noise.lacunarity = 2.0
		noise.period = 5
		noise.persistence = 0.5


#returns the biome that is generated  by the next generateTileHeights call
func getBiome():
	return biome

#generates new heightmap and changes biome
func generateTileheights(x, cols):
	var result = []
	
	var biomeProbability = rand_range(0.0, 1.0)
	for i in (biomeTransitions[biome]):
		if (biomeProbability <= i[0]):
			nextBiome = i[1]
			break
	#nextBiome = biomeTransitions[biome][randi() % biomeTransitions[biome].size()]




	for i in range(x, x+cols):
		var val = 0

		var unintVal = noise.get_noise_1d(i)
		unintVal += floorLevel
		if (unintVal < 0):
			unintVal = int(unintVal* hillMultiplier)
		elif (unintVal > 0):
			unintVal = int(unintVal* valleyMultiplier)

		#must interpolate at beginning of each biome if next is different
		if (i < x+5 and biome != lastBiome):
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
			val = unintVal


		result.push_back(val)
		
		#must store last value as lastheight
		if (i == x+cols -1):
			lastHeight = 0#val

	lastBiome = biome
	biome = nextBiome
	
	
	biomeProbability = rand_range(0.0, 1.0)
	for i in (biomeTransitions[biome]):
		if (biomeProbability <= i[0]):
			nextBiome = i[1]
			break
	
	#nextBiome = biomeTransitions[biome][randi() % biomeTransitions[biome].size()]
	setBiome(biome)

	return result





#OLD, EXISTS AS A BACKUP IF SOMETHING BREAKS WITH INTERPOLATION
var started = false
var lastY = 0
var offset = 0
func generateTileHeights_old(x, cols):

	var result = []
	var firstVal = int(noise.get_noise_1d(x) * hillMultiplier+offset)
	if (started and abs(firstVal - lastY) > 1):
		offset += lastY - firstVal
	for i in range(x, x+cols):
		var val = int(noise.get_noise_1d(i) * hillMultiplier + offset)

		result.push_back(val)
		if (i == x+cols-1):
			lastY = val
			started = true
	var biome = biomeArray[randi() % biomeArray.size()]
	setBiome(biome)
	return result
