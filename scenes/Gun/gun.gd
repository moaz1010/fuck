extends Node2D


@onready var muzzle: Marker2D = $Marker2D
@onready var cool_down_timer : Timer = %CooldownTimer
const BULLET = preload("res://scenes/Bullet/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _process(_delta: float) -> void:


	if Input.is_action_pressed("fire") and cool_down_timer.is_stopped():  # to shoot
		cool_down_timer.start()
		var bullet_instance = BULLET.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.global_rotation = global_rotation
