extends Sprite2D

@export var flag_to_activate: String



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Flags.activate_flag(Flags.flags_enum.flag_to_activate)
