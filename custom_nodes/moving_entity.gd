extends CharacterBody2D
class_name MovingEntity

@export var SECONDS_TO_MAX_SPEED := .9 
@export var SECONDS_TO_STOP_COMPLETELY := .4

@export var MAX_SPEED := 500.0
@export var JUMP_VELOCITY := 400.0

@export var MAX_SPEED_JUMP_INCREASE := .1

var speed_jump_multiplier : float = 1
var direction : float = 0
var ACCELERATION : float
var FRICTION : float

func _init() -> void:
	
	ACCELERATION = MAX_SPEED / SECONDS_TO_MAX_SPEED
	FRICTION = MAX_SPEED / SECONDS_TO_STOP_COMPLETELY
	
	#Adjusting acceleration, since friction is applied even when moving.
	ACCELERATION += FRICTION


func _physics_process(delta: float) -> void:
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
		
	#Handle acceleration.
	if direction:
		velocity.x += direction * ACCELERATION * delta
		
		
	#Handle friction.
	var friciton_direction : int = -(sign(velocity.x))
	velocity.x += FRICTION * friciton_direction * delta
	
	if friciton_direction == sign(velocity.x):
		velocity.x = 0
		
		
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED) #Clamping speed.
	
	
	speed_jump_multiplier = ((abs(velocity.x) / MAX_SPEED) * MAX_SPEED_JUMP_INCREASE) + 1
	
		
	move_and_slide()

func jump():
	velocity.y = -JUMP_VELOCITY * speed_jump_multiplier
