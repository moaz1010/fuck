extends Sprite2D

var has_fallen: bool = false


func _on_activation_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !has_fallen:
		var opacity_tween: Tween = create_tween().set_trans(Tween.TRANS_SINE)
		var pos_tween: Tween = create_tween().set_trans(Tween.TRANS_SINE)
		
		opacity_tween.tween_property(self, "modulate:a", 0.0, 0.5)
		pos_tween.tween_property(self, "global_position", global_position + Vector2(0,12), 0.5)
		
		opacity_tween.finished.connect(_disable_area)
		
		has_fallen = true
		
		$Timer.start()
		
		
func _disable_area():
	$StaticBody2D/CollisionShape2D.disabled = true


func _on_timer_timeout() -> void:         # i wanted to make the platform appear again after
	has_fallen = false                    # the timer finished but idk how to
