extends Node2D
var desired_offset: Vector2
var max_offset : int = 50 
var resistance : int = 5

func _process(_delta: float) -> void:
	desired_offset = (
		get_viewport().get_mouse_position() - 
		get_viewport().get_visible_rect().size/2
		) / resistance
	desired_offset.x = clamp(desired_offset.x , -max_offset, max_offset)
	desired_offset.y = clamp(desired_offset.y , -max_offset , max_offset)
	#desired_offset *= abs(desired_offset.normalized())
	position = desired_offset
	
