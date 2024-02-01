class_name GameController
extends Node

signal change_layer

@onready var input_controller: InputController = $InputController
@onready var tile_select_material: ShaderMaterial = load("res://resources/materials/TileSelectMaterial.material")
@onready var procedural_word_controller: ProceduralWordController = $procedural_word_controller
@onready var map: TileMap = $procedural_word_controller/TileMap
@export var tile_size: float = 64.
@export var depth: int = 8
@export var biomas: Array[Bioma] = [] 

@export var selected_object: Bioma
var current_lvl: int = -1:
	set(v):
		current_lvl = v
		change_layer.emit(v)

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_select_material.set_shader_parameter("tile_size", tile_size)
	procedural_word_controller.initialize(biomas)
	pass # Replace with function body.


func _on_procedural_word_on_generation_completed():
	current_lvl = depth / 2

func _on_input_controller_mouse_click(coord):
	print(coord)
	procedural_word_controller.place_object(Vector3i(coord.x,coord.y,current_lvl), selected_object)
	pass # Replace with function body.
