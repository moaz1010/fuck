extends Camera2D




func _on_camera_shake_component_offset_changed(value: Vector2) -> void:
	offset = value

func _ready() -> void:
	ChunkBoundries.limit_changed.connect(
		func(value): 
			limit_left = value.left
			limit_top = value.top
			limit_right = value.right
			limit_bottom = value.bottom)
