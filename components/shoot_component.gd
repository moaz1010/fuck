extends Marker2D
class_name ShootComponent


signal bullet_shot(recoil: float)

@export var cool_down : float = 1
var cool_down_timer : SceneTreeTimer
var is_in_cooldown := false

@export var BULLET : PackedScene

@export var RECOIL: float = 200.0


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("fire") and not is_in_cooldown:  # to shoot
		shoot.call_deferred()
		
func shoot():
	bullet_shot.emit(RECOIL)
	
	is_in_cooldown = true
	cool_down_timer = get_tree().create_timer(cool_down)
	cool_down_timer.timeout.connect(func(): is_in_cooldown = false)
	
	var bullet_instance = BULLET.instantiate()
	
	get_tree().root.add_child(bullet_instance)
	bullet_instance.global_position = global_position
	bullet_instance.global_rotation = global_rotation
