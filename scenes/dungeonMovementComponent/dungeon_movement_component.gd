extends Node
class_name DungeonMovementComponent

@onready var parent = get_parent()

@export var sprite: Sprite2D
@export var upper_raycast2d: RayCast2D
@export var lower_raycast2d: RayCast2D
@export var right_raycast2d: RayCast2D
@export var left_raycast2d: RayCast2D

const tile_size: Vector2 = Vector2(16, 16)
var sprite_node_position_tween: Tween


func _move(dir: Vector2):
	parent.global_position += dir * tile_size
	sprite.global_position -= dir * tile_size
	
	if sprite_node_position_tween:
		sprite_node_position_tween.kill()
	sprite_node_position_tween = create_tween()
	sprite_node_position_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_position_tween.tween_property(sprite, "global_position", parent.global_position, 0.15).set_trans(Tween.TRANS_SINE)


func _physics_process(delta):
	if Input.is_action_just_pressed("move_up"):
		try_move(Vector2.UP, upper_raycast2d)
	elif Input.is_action_just_pressed("move_down"):
		try_move(Vector2.DOWN, lower_raycast2d)
	elif Input.is_action_just_pressed("move_left"):
		try_move(Vector2.LEFT, left_raycast2d)
	elif Input.is_action_just_pressed("move_right"):
		try_move(Vector2.RIGHT, right_raycast2d)

func try_move(dir: Vector2, ray: RayCast2D):
	ray.force_raycast_update()
	if ray.is_colliding():
		return
	_move(dir)
