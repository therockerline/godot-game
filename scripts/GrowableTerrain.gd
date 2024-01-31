class_name GrowableTerrain
extends Bioma

@export var grove_ratio: float
var qnt: int
# Called when the node enters the scene tree for the first time.
func grow(tile_map: TileMap, layer: Layer, position: Vector2i):
	print('place in {0}'.format([position]))
	if layer.depth > 0:
		var data = tile_map.get_cell_tile_data(layer.depth - 1, position)
		if data:
			var bioma: Bioma = data.get_custom_data('bioma')
			print('data {0}'.format([bioma]))
			if bioma.bearer:
				tile_map.set_cells_terrain_connect(layer.map_depth,[position], self.terrain_set,self.terrain)
				qnt -= 1
				var surrounding_cells: Array[Vector2i] = tile_map.get_surrounding_cells(position)
				print(surrounding_cells)
				var best_tile: Vector2i
				for cell in surrounding_cells:
					var cell_data = tile_map.get_cell_tile_data(layer.map_depth, cell)
					print('surrounding {0} {1}'.format([cell, cell_data]))
					if cell_data:
						var cell_bioma: Bioma = cell_data.get_custom_data('bioma')
						print('cell_bioma {0}'.format([cell_bioma]))
		else:
			tile_map.set_cells_terrain_connect(layer.map_depth,[position], self.terrain_set,self.terrain)
			await tile_map.get_tree().create_timer(0.1).timeout
			tile_map.set_cells_terrain_connect(layer.map_depth,[position], -1,-1)
			layer.set_depth(layer.depth-1)	
			print('drop down {0}'.format([layer.depth]))	
			self.grow(tile_map, layer,position)


