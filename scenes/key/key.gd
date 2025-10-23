extends Node2D

@export var flag_to_activate: Flags.flags_enum



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		pass
