extends Node2D

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	rotation_degrees = wrap(rotation_degrees, 0 ,360) 
	# to invert sprite if looking opposite direction
	if rotation_degrees > 90 and rotation_degrees < 270:   
		scale.y = -1 
	else:
		scale.y = 1
