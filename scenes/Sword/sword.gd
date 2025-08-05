extends Node2D

var can_slash := true
@export var slash_time := 0.2
@export var sword_return_time := 0.5
@export var weapon_damage := 1.0

@onready var animation_player := $AnimationPlayer

func _input(_event: InputEvent) -> void:
		if Input.is_action_pressed("fire") and can_slash:
			animation_player.speed_scale = animation_player.get_animation("slash").length / slash_time
			animation_player.play("slash")
			can_slash = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slash":
		animation_player.speed_scale = animation_player.get_animation("sword_return").length / sword_return_time
		animation_player.play("sword_return")
	else:
		can_slash = true
