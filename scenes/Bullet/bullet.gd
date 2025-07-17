extends Area2D

const SPEED: int = 300
const damage := 4.0


func _process(delta: float) -> void:
	position += transform.x * SPEED * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	if body.has_method("push"):
		var direction: float = sign(body.global_position.x - global_position.x)
		body.push(Vector2.RIGHT * direction, (SPEED / 3))
	queue_free()
