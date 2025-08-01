extends Control


@onready var grids_container = $levelMenu/Control/gridsContainer

var num_grids = 1
var current_grid = 1
var grid_width = 165
var level_num: int = 0

func _ready() -> void:
	num_grids = grids_container.get_child_count()
	grid_width = grids_container.custom_minimum_size.x
	setup_level_box()
	
func setup_level_box():
	var count := 0
	for box in get_tree().get_nodes_in_group("level_button"):
		box.level_num = count + 1
		count += 1
		box.locked = false

func _on_back_button_pressed() -> void:
	if current_grid > 1:
		current_grid -= 1
	animate_grids_positon(grids_container.position.x + grid_width)

func _on_next_button_pressed() -> void:
	if current_grid < num_grids:
		current_grid += 1
	animate_grids_positon(grids_container.position.x - grid_width)

func animate_grids_positon(finalValue):
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_property(
		grids_container, "position:x", finalValue, 0.5
	)
