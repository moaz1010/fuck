extends Node2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		$AnimationPlayer.play("slash")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass
