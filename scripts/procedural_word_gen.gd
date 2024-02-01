class_name ProceduralWordController
extends Node2D

@onready var GC: GameController = $".."
@onready var tile_map: TileMap = $TileMap
@export var noise_map: NoiseTexture3D
signal onGenerationCompleted

var biomas: Array[Bioma] = [] 
var map: Dictionary = {}
var layers: Array[Layer] = []
var noise: Noise
const planes = [0,1]

func half_range(dim: int):
	return range(-dim/2.0, dim/2.0)
	
func create_layer(depth: int, plane: int):
	var layer = Layer.new(depth,plane,len(planes))
	tile_map.add_layer(layer.map_depth)
	tile_map.set_layer_y_sort_enabled(layer.map_depth, true)
	tile_map.set_layer_z_index(layer.map_depth,layer.map_depth)
	tile_map.set_layer_name(layer.map_depth, layer.name)
	return layer

class BiomaTile:
	var bioma: Bioma
	var coord: Vector3i
	func _init(b: Bioma, c:Vector3i):
		bioma = b
		coord = c
		
	func coord2i() -> Vector2i:
		return Vector2i(coord.x, coord.y)
	
func vector_to_key(coord: Vector3i) -> String:
	return '{0}_{1}'.format([coord.x, coord.y])

func key_to_vector(key: String) -> Vector2i:
	var coords = key.split("_")
	return Vector2i(int(coords[0]), int(coords[1]))
	
func generate():
	print(biomas)
	if(tile_map && noise_map):
		noise = noise_map.noise
		var noises = []
		
		#costruisco i layer e inizializzo la mappa
		for z in range(noise_map.depth):
			for plane in planes:
				var layer = create_layer(z, plane)
				layers.append(layer)
				map[layer.map_depth] = {}
				
		
		for layer in layers:
			for x in half_range(noise_map.width):
				for y in half_range(noise_map.height):	
					var z = layer.depth
					var coord = Vector3i(x,y,layer.map_depth)
					var selected_bioma: Bioma = null			
					for b: Bioma in biomas:				
						var point = noise.get_noise_3dv(coord)
						noises.append(point)
						if(point >= b.tile_map_offset):
							if(z >= b.range_start && z <= b.range_end):
								selected_bioma = b
								pass					
					if selected_bioma:
						var coord_key = vector_to_key(coord)
						var b_tile = BiomaTile.new(selected_bioma, coord)
						if z > 0:
							if map[z-1].has(coord_key):
								var sub_tile: BiomaTile = map[z-1][coord_key]
								if(sub_tile and sub_tile.bioma.bearer):
									map[z][coord_key] = b_tile	
						else:
							map[z][coord_key] = b_tile
		print('MIN: {0}\nMAX: {1}'.format([noises.min(),noises.max()]))
		paint_terrains()

func paint_terrains():
	for layer in layers:
		var z = layer.depth
		var tiles = {}			
		for coord_key:String in map[z].keys():
			var b_tile: BiomaTile = map[z][coord_key]
			if b_tile.bioma:
				if not tiles.has(b_tile.bioma.bioma_name):
					tiles[b_tile.bioma.bioma_name] = {
						"bioma": b_tile.bioma,
						"coords": []
					}
				tiles[b_tile.bioma.bioma_name].coords.append(b_tile.coord2i())
		for b_name in tiles.keys(): 
			var elem = tiles[b_name]
			tile_map.set_cells_terrain_connect(layer.map_depth, elem.coords, elem.bioma.terrain_set, elem.bioma.terrain)

func initialize(_biomas: Array[Bioma]):
	biomas =_biomas
	tile_map.y_sort_enabled = true
	generate()
	emit_signal("onGenerationCompleted")
	
func _init():
	print('init')
	pass

func _on_game_controller_change_layer(current_layer: int):
	print(current_layer)
	if tile_map.get_layers_count() > 0:
		for layer in layers:
			var z = layer.depth
			if z > current_layer:
				tile_map.set_layer_modulate(layer.map_depth, Color(1,1,1,0))
			elif z == current_layer:
				tile_map.set_layer_modulate(layer.map_depth, Color(1,1,1,1))
			else:
				var m = 1.0 - ((0.9 / (noise_map.depth /2.0)) * (current_layer - z + 10))
				if m < 0:
					m=0
				tile_map.set_layer_modulate(layer.map_depth, Color(m,m,m,1))

				


func place_object(coord: Vector3i, object: GrowableTerrain):
	print('place {0}'.format([coord]))
	var layer = Layer.new(coord.z, object.plane, len(planes))
	var pos = Vector2i(coord.x,coord.y)
	object.qnt = 15
	object.grow(tile_map, layer,pos)
