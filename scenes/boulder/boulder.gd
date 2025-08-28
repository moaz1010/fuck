extends CharacterBody2D

@export var gravity := 500.0
var should_start_falling : bool = false

func _physics_process(delta: float) -> void:
	if should_start_falling:
		velocity.y += gravity*delta
	move_and_slide()

func _on_enter_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$AnimationPlayer.play("shaking")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shaking":
		should_start_falling = true
