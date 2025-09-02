extends Node
class_name PlatformerComponent

var velocity : Vector2 = Vector2.ZERO

var SECONDS_TO_MAX_SPEED := .9:
	set(value):
		SECONDS_TO_MAX_SPEED = value
		ACCELERATION = MAX_SPEED / SECONDS_TO_MAX_SPEED

var SECONDS_TO_STOP_COMPLETELY := .4:
	set(value):
		SECONDS_TO_STOP_COMPLETELY = value
		FRICTION = MAX_SPEED / SECONDS_TO_STOP_COMPLETELY

var HANG_TIME := .5:
	set(value):
		HANG_TIME = value
		JUMP_VELOCITY = (2 * JUMP_HEIGHT) / HANG_TIME
		GRAVITY = JUMP_VELOCITY / HANG_TIME

var FALL_TIME := .25:
	set(value):
		FALL_TIME = value
		FALL_GRAVITY = (2 * JUMP_HEIGHT) / pow(FALL_TIME, 2)

var JUMP_HEIGHT := 160.0:
	set(value):
		JUMP_HEIGHT = value
		JUMP_VELOCITY = (2 * JUMP_HEIGHT) / HANG_TIME
		FALL_GRAVITY = (2 * JUMP_HEIGHT) / pow(FALL_TIME, 2)
		MAX_JUMP_VELOCITY = sqrt(2*GRAVITY*(JUMP_HEIGHT+MAX_SPEED_JUMP_INCREASE))

var MAX_SPEED := 300.0:
	set(value):
		MAX_SPEED = value
		ACCELERATION = MAX_SPEED / SECONDS_TO_MAX_SPEED
		FRICTION = MAX_SPEED / SECONDS_TO_STOP_COMPLETELY

var TERMINAL_VELOCITY := 1000.0

var ACCELERATION : float
var FRICTION : float
var GRAVITY : float = 200
var FALL_GRAVITY : float = 300
var MAX_SPEED_JUMP_INCREASE := .1
var JUMP_VELOCITY := 400.0
var MAX_JUMP_VELOCITY := 600.0

var direction : float = 0

var should_control_itself : bool = true
var lock_movement : bool = false

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


func _ready() -> void: _setup_from_resource(params)


func calculate(delta: float, is_on_floor: bool = true, is_on_wall: bool = false) -> Vector2:

	_apply_gravity(delta, is_on_wall)

	_apply_acceleration(delta)

	_apply_friction(delta, is_on_floor)

	velocity += velocity_increase
	velocity_increase = Vector2.ZERO
	velocity.y = clamp(velocity.y, -TERMINAL_VELOCITY, TERMINAL_VELOCITY)
	
	return velocity


func jump():
	if lock_movement: return
	var percentage = min(abs(velocity.x) / MAX_SPEED, 1)
	var increase = lerp(JUMP_VELOCITY, MAX_JUMP_VELOCITY, percentage)
	velocity.y = -increase

func push(push_direction: Vector2, power: float = 1):
	should_control_itself = false
	velocity += push_direction * power

func insta_push(push_direction: Vector2, power: float = 1):
	should_control_itself = false
	velocity = push_direction * power



func _apply_gravity(delta: float, is_on_wall: bool = false):
		if velocity.y > 0:
			velocity.y += FALL_GRAVITY * delta
		else:
			velocity.y += GRAVITY * delta

		if is_on_wall: velocity.y = min(velocity.y, 10)

func _apply_acceleration(delta: float):
	if lock_movement: return
	#Handle acceleration.
	if direction:
		should_control_itself = true
		var increase := (ACCELERATION + FRICTION) * delta
		
		#To make sure the character doesn't go beyond 
		#max speed while allowing external forces
		#to push it beyond max speed.
		if abs(velocity.x + increase*direction) > MAX_SPEED:
			increase = (MAX_SPEED - abs(velocity.x) + (FRICTION * delta))
	
		increase = max(increase, 0)
		
		velocity.x += increase * direction


func _apply_friction(delta: float, is_on_floor: bool = true):
	#Handle friction.
	var friciton_direction : int = -(sign(velocity.x))
	var decrease = FRICTION * friciton_direction
	if not should_control_itself: 
		decrease /= 2.0
		if not is_on_floor: decrease /= 4.0
	velocity.x += decrease * delta
	
	if friciton_direction == sign(velocity.x):
		velocity.x = 0
