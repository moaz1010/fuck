extends Node2D
class_name SwordSlash
var weapon_damage := 1.0

func slash() -> void:
	$Sprite2D/AnimationPlayer.play("slash")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(weapon_damage)
	
