extends MovingEntity

@onready var coyote_timer := %CoyoteTimer
@onready var jump_buffer := %JumpBuffer

var was_on_floor: bool = true
var wants_to_jump: bool = false

func _input(_event: InputEvent) -> void:


	if Input.is_action_just_pressed("move_up"):
		wants_to_jump = true
		jump_buffer.start()



	direction = Input.get_axis("move_left", "move_right")


func _process(_delta: float) -> void:
	if not is_on_floor() and was_on_floor:
		coyote_timer.start()
	was_on_floor = is_on_floor()

	if jump_buffer.is_stopped(): wants_to_jump = false


	if wants_to_jump:
		if is_on_floor() or !coyote_timer.is_stopped(): 
			jump()
			was_on_floor = false
			wants_to_jump = false
		coyote_timer.stop()
