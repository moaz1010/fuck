extends Sprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if "health" in body :
		body.health -= 1
		if body.health > 0.0 :
			return
	
	if !body.is_in_group("player"):
		return
	
	
