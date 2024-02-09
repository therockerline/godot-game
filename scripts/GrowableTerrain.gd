class_name GrowableTerrain
extends Bioma

@export var growth_speed: float = 0.1
@export var drop_speed: float = 0.1
var qnt: int = 3
var tile_map: TileMap
var noise: Noise
var visited: Array[Vector3i]

func can_place(depth: int, position: Vector2i):
	var data = tile_map.get_cell_tile_data(depth, position)
	if data or depth == 0:
		var bioma: Bioma = data.get_custom_data('bioma')
		return bioma.bearer and qnt > 0
	return false
	
func place(depth: int, position: Vector2i, isDrop: bool = false):
	if qnt > 0:
		tile_map.set_cells_terrain_connect(depth,[position], terrain_set,terrain)
		if not isDrop:
			qnt -= 1

func drop(layer: Layer, position: Vector2i):
	print('drop down {0}'.format([layer.depth]))
	place(layer.map_depth,position, true)
	await tile_map.get_tree().create_timer(drop_speed).timeout
	#rimuovo la cella precedente
	tile_map.set_cell(layer.map_depth,position, -1)
	#scendo di quota
	layer.set_depth(layer.depth-1)	
	#provo a diffondermi
	grow(tile_map, noise, layer, position)
	
func try_join(depth: int, position: Vector2i):
	var data = tile_map.get_cell_tile_data(depth, position)
	if data:
		var bioma: Bioma = data.get_custom_data('bioma')
		if bioma:
			#verifico se l'oggetto è  lo stesso
			if bioma.bioma_name == bioma_name:
				#in questo caso mi prendo la sua quantità
				print('{0} {1}'.format([qnt, bioma.qnt]))
				#qnt += bioma.qnt
				#bioma.qnt = 1
	
# Called when the node enters the scene tree for the first time.
func grow(tile_map: TileMap, noise: Noise,  layer: Layer, position: Vector2i):	
	var coord: Vector3i = Vector3i(position.x, position.y, layer.map_depth)
	print('place in {0} qnt: {1}, noise: {2}'.format([position, qnt, noise.get_noise_3dv(coord)]))
	
	if not self.tile_map:
		self.tile_map = tile_map
	if not self.noise:
		self.noise = noise
	if layer.depth >= 0:
		#questi sono i dati del tile inferiore
		if can_place(layer.getBelow(), position):
			#se il bioma inferiore è portante allora a questa altezza (layer.map_depth) posso generare il mio elemento
			place(layer.map_depth,position)
			#visited.append(coord)
			var surrounding_cells: Array[Vector2i] = tile_map.get_surrounding_cells(position)
			await tile_map.get_tree().create_timer(growth_speed).timeout
			var best_cell = null
			var min = INF
			for cell in surrounding_cells:
				var cell3 = Vector3i(cell.x,cell.y, layer.map_depth)
				#if 	not visited.has(cell3):		
				var v = noise.get_noise_3dv(cell3)
				if v < min:
					min = v
					best_cell = cell
				print('check {0} {1}'.format([cell, v]))
			if best_cell:
				#provo ad unire con la cella adiacente se dello stesso tipo
				try_join(layer.map_depth, best_cell)			
				#poi diffondo
				self.grow(tile_map, noise, layer, best_cell)
		else:
			drop(layer, position)			


