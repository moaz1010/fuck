extends CharacterBody2D

var to_be_followed : Array[Node2D]

var speed := 65.0 
var direction : Vector2

func _physics_process(delta: float) -> void:
	if not to_be_followed.is_empty(): 
		direction = (to_be_followed[0].global_position-global_position).normalized()
	else: direction = Vector2.ZERO
	velocity = lerp(velocity, direction * speed, 8.5 * delta )
	move_and_slide()
		
	if direction.x > 0:
		$Sprite2D.flip_h = false
	elif direction.x < 0:
		$Sprite2D.flip_h = true


func _on_enter_area_body_entered(body: Node2D) -> void:
	to_be_followed.append(body)


#func _on_exit_area_body_entered(body: Node2D) -> void:
	#if body == player_node:
		#should_chase = false


func _on_exit_area_body_exited(body: Node2D) -> void:
	var index = to_be_followed.find(body)
	if index >= 0: to_be_followed.remove_at(index)
