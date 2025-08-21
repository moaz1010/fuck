extends CharacterBody2D

var SPEED: int = 300

@export var explosion : PackedScene

func _physics_process(delta: float) -> void:
	velocity = Vector2.RIGHT*SPEED*delta
	velocity = velocity.rotated(global_rotation)
	var collision = move_and_collide(velocity)
	if collision:
		_split.call_deferred()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(_body: Node2D) -> void:
	_split.call_deferred()


func _split():
	var new_explosion = explosion.instantiate()
	get_tree().root.add_child(new_explosion)
	new_explosion.global_position = global_position
	queue_free()


func _on_split_timer_timeout() -> void:
	_split.call_deferred()
