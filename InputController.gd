class_name InputController
extends Node2D

@onready var GC: GameController = $".."
signal mouse_click
# Called when the node enters the scene tree for the first time.
func _init():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if Input.is_action_just_pressed("scroll_up") && GC.current_lvl > 0:
		GC.current_lvl -= 1 
	elif Input.is_action_just_pressed("scroll_down") && GC.current_lvl < GC.depth:
		GC.current_lvl += 1
	elif Input.is_action_pressed("mouse_move"):
		print(get_viewport().get_mouse_position())
		

	var mouse_pos = get_global_mouse_position()
	var tile_pos = GC.map.local_to_map(mouse_pos)
	var position = GC.map.map_to_local(tile_pos)
	var cell_id = GC.map.get_cell_source_id(GC.current_lvl,tile_pos)
	var is_selectable = 0.
	if cell_id != -1:
		is_selectable = 1.0
	GC.tile_select_material.set_shader_parameter("mouse_position", position + (Vector2.ONE * GC.tile_size/2.))
	GC.tile_select_material.set_shader_parameter("is_selectable", is_selectable)
	
	if Input.is_action_just_pressed("mouse_click"):
		emit_signal('mouse_click', tile_pos)
		print(tile_pos)

