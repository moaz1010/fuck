extends CharacterBody2D
class_name MovingEntity


@export var SPEED := 300.0
@export var JUMP_VELOCITY := -400.0

var direction : float = 0



func _physics_process(delta: float) -> void:
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func jump():
	velocity.y = JUMP_VELOCITY
