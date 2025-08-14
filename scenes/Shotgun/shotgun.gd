extends Node2D
class_name Shotgun


@onready var muzzle: Marker2D = $Marker2D
@onready var cool_down_timer : Timer = %CooldownTimer
const BULLET = preload("res://scenes/Bullet/bullet.tscn")
@export var RECOIL: float = 400.0
signal bullet_shot(recoil: float)

@onready var animation_player = $AnimationPlayer

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("fire"):
		animation_player.play("shoot")

func shoot():
	bullet_shot.emit(RECOIL)
	cool_down_timer.start()
	for i in range(-1, 2):
		var bullet_instance = BULLET.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.global_rotation_degrees = (
				global_rotation_degrees + (15 * i)
			)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shoot":
		animation_player.play("default")
