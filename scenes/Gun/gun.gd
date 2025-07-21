extends Node2D


@onready var muzzle: Marker2D = $Marker2D
@onready var cool_down_timer : Timer = %CooldownTimer
const BULLET = preload("res://scenes/Bullet/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _process(_delta: float) -> void:

	look_at(get_global_mouse_position()) #to make the gun look at the mouse
	
	rotation_degrees = wrap(rotation_degrees, 0 ,360)
	if rotation_degrees > 90 and rotation_degrees < 270:   # to invert sprite if looking opposite direction
		scale.y = -1 
	else:
		scale.y = 1
		
	if Input.is_action_pressed("fire") and cool_down_timer.is_stopped():  # to shoot
		cool_down_timer.start()
		var bullet_instance = BULLET.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.rotation = rotation
