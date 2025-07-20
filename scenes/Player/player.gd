extends MovingEntity

@onready var coyote_timer = %CoyoteTimer

var was_on_floor: bool = true

func _input(_event: InputEvent) -> void:

	direction = Input.get_axis("move_left", "move_right")

	if Input.is_action_just_pressed("move_up"):
		if is_on_floor() or !coyote_timer.is_stopped(): 
			jump()
			was_on_floor = false
		coyote_timer.stop()


func _process(_delta: float) -> void:
	if not is_on_floor() and was_on_floor:
		coyote_timer.start()
	was_on_floor = is_on_floor()
