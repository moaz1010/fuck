extends Sprite2D

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
			
		if Input.is_action_just_pressed("fire"):
			animation_player.play("slash")
			can_slash = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slash":
		animation_player.speed_scale = animation_player.get_animation("sword_return").length / sword_return_time
		animation_player.play("sword_return")
	else:
		can_slash = true

const sword_slash_preload = preload("res://scenes/sword_slash.tscn")
func spawn_slash():
	var sword_slash_var = sword_slash_preload.instantiate()
	sword_slash_var.global_position = global_position
	sword_slash_var.get_node("WeaponShell/Sprite2D/AnimationPlayer2").speed_scale = sword_slash_var.get_node("WeaponShell/Sprite2D/AnimationPlayer2").get_animation("slash").length / slash_time
	sword_slash_var.get_node("WeaponShell/Sprite2D").flip_v = false if get_global_mouse_position().x > global_position.x else true
	sword_slash_var.weapon_damage = weapon_damage
	get_parent().add_child(sword_slash_var)
