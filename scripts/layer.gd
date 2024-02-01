class_name Layer
extends Node

var depth: int
var plane: int
var map_depth: int
var planes_len: int

func _init(_depth: int, _plane: int, _planes_len: int):
	self.name = "{0}_{1}".format([_depth, _plane])	
	self.plane = _plane
	self.planes_len = _planes_len
	set_depth(_depth)
	
func set_depth(_depth: int):
	self.depth = _depth
	self.map_depth = self.planes_len * _depth + self.plane
	
func getBelow():
	return map_depth - planes_len

func getAbove():
	return map_depth + planes_len
