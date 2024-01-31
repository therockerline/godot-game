class_name InputController
extends Node2D

@onready var GC: GameController = $".."
signal mouse_click

var prev_mouse_tile_pos: Vector2i
var current_mouse_tile_pos: Vector2i
var is_mouse_action_emitted = false
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
	
	current_mouse_tile_pos = mouse_to_tile()
	if Input.is_action_just_pressed("mouse_click") and not is_mouse_action_emitted:
		is_mouse_action_emitted = true
		mouse_action()
		
	if is_mouse_action_emitted and Input.is_action_just_released("mouse_click"):
		is_mouse_action_emitted = false
		
	var position = GC.map.map_to_local(current_mouse_tile_pos)
	var cell_id = GC.map.get_cell_source_id(GC.current_lvl,current_mouse_tile_pos)
	var is_selectable = 0.
	if cell_id != -1:
		is_selectable = 1.0
	GC.tile_select_material.set_shader_parameter("mouse_position", position + (Vector2.ONE * GC.tile_size/2.))
	GC.tile_select_material.set_shader_parameter("is_selectable", is_selectable)
	
func mouse_to_tile():
	var mouse_pos = get_global_mouse_position()
	var tile_pos = GC.map.local_to_map(mouse_pos)
	return tile_pos 
	
func mouse_action():
	if is_mouse_action_emitted:
		if prev_mouse_tile_pos != current_mouse_tile_pos:
			prev_mouse_tile_pos = current_mouse_tile_pos
			emit_signal('mouse_click', current_mouse_tile_pos)
		await get_tree().create_timer(0.01).timeout
		mouse_action()
