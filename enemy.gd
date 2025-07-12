extends CharacterBody2D


@onready var player_node: CharacterBody2D = get_parent().get_node("player")

var speed := 65.0
var should_chase := false 


func _physics_process(delta: float) -> void:
	if should_chase:
		var direction = (player_node.global_position-global_position).normalized()
		velocity = lerp(velocity, direction * speed, 8.5 * delta )
		move_and_slide()
		
		if direction.x > 0:
			$Sprite2D.flip_h = false
		elif direction.x < 0:
			$Sprite2D.flip_h = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player_node:
		get_tree().call_deferred("reload_current_scene")


func _on_enter_area_body_entered(body: Node2D) -> void:
	if body == player_node:
		should_chase = true


func _on_exit_area_body_entered(body: Node2D) -> void:
	if body == player_node:
		should_chase = false
