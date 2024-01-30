class_name GrowableTerrain
extends Node2D

@export var bioma: Bioma 
@export var grove_ratio: float
@export var qnt: int
var tile_map: TileMap
# Called when the node enters the scene tree for the first time.
func grow(layer: int, position: Vector2i):
	var tile_data: TileData = tile_map.get_cell_tile_data(layer, position)
	print(tile_data)

func _init(tile_map: TileMap):
	self.tile_map = tile_map
