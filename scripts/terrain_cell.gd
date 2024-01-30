class_name TerrainCell
extends Resource

@export var cells: Array[Vector2i]
@export var layer: int


func _init(layer: int, cells: Array[Vector2i]):
	self.layer = layer
	self.cells = cells


