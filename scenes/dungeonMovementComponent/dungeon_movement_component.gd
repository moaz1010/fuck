extends Node
class_name DungeonMovementComponent

@onready var parent = get_parent()

const tile_size: Vector2 = Vector2(16, 16)
var sprite_node_position_tween: Tween

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("move_up") and ! $up.is_colliding():
		_move(Vector2(0, -1))
	elif Input.is_action_just_pressed("move_down") and ! $down.is_colliding():
		_move(Vector2(0, 1))
	elif Input.is_action_just_pressed("move_left") and ! $left.is_colliding():
		_move(Vector2(-1, 0))
	elif Input.is_action_just_pressed("move_right") and ! $right.is_colliding():
		_move(Vector2(1, 0))
		
func _move(dir: Vector2):
	parent.global_position += dir * tile_size
	$Sprite2D.global_position -= dir * tile_size
	
	if sprite_node_position_tween:
		sprite_node_position_tween.kill()
	sprite_node_position_tween = create_tween()
	sprite_node_position_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_position_tween.tween_property($Sprite2D, "global_position", parent.global_position, 0.005).set_trans(Tween.TRANS_SINE)
