extends CharacterBody2D
class_name MovingEntity


var SECONDS_TO_MAX_SPEED := .9 
var SECONDS_TO_STOP_COMPLETELY := .4
var HANG_TIME := .5
var FALL_TIME := .25
var JUMP_HEIGHT := 160.0

var MAX_SPEED := 300.0
var TERMINAL_VELOCITY := 1000.0

var direction : float = 0
var is_dashing : bool = false
var dash_vector : Vector2 = Vector2.ZERO

var ACCELERATION : float
var FRICTION : float
var GRAVITY : float = 200
var FALL_GRAVITY : float = 300
var MAX_SPEED_JUMP_INCREASE := .1
var JUMP_VELOCITY := 400.0
var MAX_JUMP_VELOCITY := 600.0

var velocity_increase: Vector2 = Vector2.ZERO

@export var params : MovingEntityStats:
	set(resource):
		params = resource
		_setup_from_resource(resource)

func _setup_from_resource(resource: MovingEntityStats) -> void:
	if resource != null:
		SECONDS_TO_MAX_SPEED = resource.SECONDS_TO_MAX_SPEED
		SECONDS_TO_STOP_COMPLETELY = resource.SECONDS_TO_STOP_COMPLETELY
		HANG_TIME = resource.HANG_TIME
		FALL_TIME = resource.FALL_TIME 
		MAX_SPEED = resource.MAX_SPEED
		MAX_SPEED_JUMP_INCREASE = resource.MAX_SPEED_JUMP_INCREASE
		JUMP_HEIGHT = resource.JUMP_HEIGHT

	ACCELERATION = MAX_SPEED / SECONDS_TO_MAX_SPEED
	FRICTION = MAX_SPEED / SECONDS_TO_STOP_COMPLETELY

	JUMP_VELOCITY = (2 * JUMP_HEIGHT) / HANG_TIME

	GRAVITY = JUMP_VELOCITY / HANG_TIME
	MAX_JUMP_VELOCITY = sqrt(2*GRAVITY*(JUMP_HEIGHT+MAX_SPEED_JUMP_INCREASE))
	FALL_GRAVITY = (2 * JUMP_HEIGHT) / pow(FALL_TIME, 2)


func _ready() -> void: _setup_from_resource(params)


func _physics_process(delta: float) -> void:


	if not is_dashing:
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
		var decrease = FRICTION * friciton_direction * delta
		velocity.x += decrease
		
		if friciton_direction == sign(velocity.x):
			velocity.x = 0

	if is_dashing: velocity = dash_vector
	velocity += velocity_increase
	velocity.y = clamp(velocity.y, -TERMINAL_VELOCITY, TERMINAL_VELOCITY)
	move_and_slide()
	if is_dashing: 
		var cutoff := 3.0
		velocity = Vector2(
			sign(dash_vector.x) * ACCELERATION * delta * cutoff, 
			sign(dash_vector.y) * GRAVITY * delta * cutoff
			)
	velocity_increase = Vector2.ZERO

func jump():
	if not is_dashing:
		var percentage = min(abs(velocity.x) / MAX_SPEED, 1)
		var increase = lerp(JUMP_VELOCITY, MAX_JUMP_VELOCITY, percentage)
		velocity.y = -increase

func dash(dash_direction: Vector2, power: float):
	dash_vector = dash_direction * power
	velocity = dash_vector

func push(push_direction: Vector2, power: float = 1):
	velocity += push_direction * power

func insta_push(push_direction: Vector2, power: float = 1):
	velocity = push_direction * power
