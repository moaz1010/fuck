extends CharacterBody2D
class_name MovingEntity

@export var params : MovingEntityStats

var SECONDS_TO_MAX_SPEED := .9 
var SECONDS_TO_STOP_COMPLETELY := .4
var HANG_TIME := .5

var MAX_SPEED := 300.0
var FALL_GRAVITY_MULTIPLIER := 2.2


var speed_jump_multiplier : float = 1
var direction : float = 0
var ACCELERATION : float
var FRICTION : float
var GRAVITY : float = 200
#TODO: CHANGE THESE TO BE RELATIVE TO CHARACTER HEIGHT
var MAX_SPEED_JUMP_INCREASE := .1
var JUMP_VELOCITY := 400.0


func _ready() -> void:
	
	if params != null:
		SECONDS_TO_MAX_SPEED = params.SECONDS_TO_MAX_SPEED
		SECONDS_TO_STOP_COMPLETELY = params.SECONDS_TO_STOP_COMPLETELY
		HANG_TIME = params.HANG_TIME
		MAX_SPEED = params.MAX_SPEED
		FALL_GRAVITY_MULTIPLIER = params.FALL_GRAVITY_MULTIPLIER
		MAX_SPEED_JUMP_INCREASE = params.MAX_SPEED_JUMP_INCREASE
		JUMP_VELOCITY = params.JUMP_VELOCITY

	ACCELERATION = MAX_SPEED / SECONDS_TO_MAX_SPEED
	FRICTION = MAX_SPEED / SECONDS_TO_STOP_COMPLETELY

	GRAVITY = JUMP_VELOCITY / HANG_TIME
	#Adjusting acceleration, since friction is applied even when moving.
	ACCELERATION += FRICTION


func _physics_process(delta: float) -> void:


	# Add the gravity.
	if velocity.y >= 0:
		velocity.y += GRAVITY * FALL_GRAVITY_MULTIPLIER * delta
	else:
		velocity.y += GRAVITY * delta


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
