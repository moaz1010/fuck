extends Area2D

var SPEED: int = 300

@export var explosion : PackedScene

func _process(delta: float) -> void:
	position += transform.x * SPEED * delta

func _on_body_entered(_body: Node2D) -> void:
	_split.call_deferred()


func _split():
	var new_explosion = explosion.instantiate()
	get_tree().root.add_child(new_explosion)
	new_explosion.global_position = global_position
	queue_free()


func _on_split_timer_timeout() -> void:
	_split.call_deferred()
