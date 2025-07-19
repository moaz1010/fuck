extends MovingEntity


func _input(_event: InputEvent) -> void:

	direction = Input.get_axis("move_left", "move_right")

	if Input.is_action_just_pressed("move_up") and is_on_floor():
		jump()
