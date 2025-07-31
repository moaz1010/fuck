extends Area2D

@export var checkpoint_id: int = 0


signal activated(pos: Vector2)

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		emit_signal("activated", global_position)
