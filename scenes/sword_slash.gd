extends Node2D
var weapon_damage := 1.0

func _ready() -> void:           # to rotate the sword towards the mouse
	look_at(get_global_mouse_position())
	$Sprite2D/AnimationPlayer.play("slash")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slash":
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(weapon_damage)
	
