extends Area2D




func _on_body_entered(body: Node2D) -> void:
	Flags.activate_flag(Flags.flags_enum.REACHED_FIRST_PARKOUR)
