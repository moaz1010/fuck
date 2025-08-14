extends Node2D
class_name Gun


@onready var muzzle: Marker2D = $Marker2D
@onready var cool_down_timer : Timer = %CooldownTimer
const BULLET = preload("res://scenes/Bullet/bullet.tscn")
@export var RECOIL: float = 200.0
signal bullet_shot(recoil: float)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("fire") and cool_down_timer.is_stopped():  # to shoot
		shoot()
		
func shoot():
	bullet_shot.emit(RECOIL)
	cool_down_timer.start()
	var bullet_instance = BULLET.instantiate()
	get_tree().root.add_child(bullet_instance)
	bullet_instance.global_position = muzzle.global_position
	bullet_instance.global_rotation = global_rotation
