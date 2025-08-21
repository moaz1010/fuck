extends Node2D

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("fire"):
		$AnimationPlayer.play("slash")
