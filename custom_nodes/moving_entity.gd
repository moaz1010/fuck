extends CharacterBody2D
class_name MovingEntity

@export var params : MovingEntityStats

var SECONDS_TO_MAX_SPEED := .9 
var SECONDS_TO_STOP_COMPLETELY := .4
var HANG_TIME := .5
var FALL_TIME := .25
var JUMP_HEIGHT := 160.0

var MAX_SPEED := 300.0

var direction : float = 0
var ACCELERATION : float
var FRICTION : float
var GRAVITY : float = 200
var FALL_GRAVITY : float = 300
var MAX_SPEED_JUMP_INCREASE := .1
var JUMP_VELOCITY := 400.0
var MAX_JUMP_VELOCITY := 600.0


func _ready() -> void:


	if params != null:
		SECONDS_TO_MAX_SPEED = params.SECONDS_TO_MAX_SPEED
		SECONDS_TO_STOP_COMPLETELY = params.SECONDS_TO_STOP_COMPLETELY
		HANG_TIME = params.HANG_TIME
		FALL_TIME = params.FALL_TIME
		MAX_SPEED = params.MAX_SPEED
		MAX_SPEED_JUMP_INCREASE = params.MAX_SPEED_JUMP_INCREASE
		JUMP_HEIGHT = params.JUMP_HEIGHT

	ACCELERATION = MAX_SPEED / SECONDS_TO_MAX_SPEED
	FRICTION = MAX_SPEED / SECONDS_TO_STOP_COMPLETELY

	JUMP_VELOCITY = (2 * JUMP_HEIGHT) / HANG_TIME
	MAX_JUMP_VELOCITY = (2 * (JUMP_HEIGHT + MAX_SPEED_JUMP_INCREASE)) / HANG_TIME

	GRAVITY = JUMP_VELOCITY / HANG_TIME
	FALL_GRAVITY = (2 * JUMP_HEIGHT) / pow(FALL_TIME, 2)



func _physics_process(delta: float) -> void:


	# Add the gravity.
	if velocity.y > 0:
		velocity.y += FALL_GRAVITY * delta
	else:
		velocity.y += GRAVITY * delta


	#Handle acceleration.
	if direction:
		var increase := (ACCELERATION + FRICTION) * delta
		
		#To make sure the character doesn't go beyond 
		#max speed while allowing external forces
		#to push it beyond max speed.
		if abs(velocity.x + increase*direction) > MAX_SPEED:
			increase = (MAX_SPEED - abs(velocity.x) + (FRICTION * delta))
		increase = max(increase, 0)
		
		velocity.x += increase * direction


	#Handle friction.
	var friciton_direction : int = -(sign(velocity.x))
	velocity.x += FRICTION * friciton_direction * delta
	
	if friciton_direction == sign(velocity.x):
		velocity.x = 0


	move_and_slide()

func jump():
	var percentage = min(abs(velocity.x) / MAX_SPEED, 1)
	velocity.y = -lerp(JUMP_VELOCITY, MAX_JUMP_VELOCITY, percentage)
