extends ShootComponent

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
