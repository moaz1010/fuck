extends Node2D



func _process(delta: float) -> void:
	if $AnimationPlayer.is_playing():
		position.y += 2

func _on_enter_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$AnimationPlayer.play("shaking")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shaking":
		pass
