extends Node2D
var offset: Vector2 
var desired_offset: Vector2
var max_offset : int = 50 
var resistance : int = 5

var shake_intensity:float = 0.0
var active_shake_time:float = 0.0

var shake_decay:float = 5.0

var shake_time:float = 0.0
var shake_time_speed:float = 20.0

var noise = FastNoiseLite.new()

func _process(delta: float) -> void:
	desired_offset = (
		get_viewport().get_mouse_position() - 
		get_viewport().get_visible_rect().size/2
		) / resistance
	desired_offset.x = clamp(desired_offset.x , -max_offset, max_offset)
	desired_offset.y = clamp(desired_offset.y , -max_offset , max_offset)
	#desired_offset *= abs(desired_offset.normalized())
	position = desired_offset
	
	if active_shake_time > 0:
		shake_time += delta * shake_time_speed
		active_shake_time -= delta
		
		offset = Vector2(
			noise.get_noise_2d(shake_time, 0) * shake_intensity,
			noise.get_noise_2d(0, shake_time) * shake_intensity
		)
		
		shake_intensity = max(shake_intensity - shake_decay * delta, 0)
		
	else:
		offset = lerp(offset, Vector2.ZERO, 10.5 * delta) 


func screen_shake(intensity:int, time:float):
	randomize()
	noise.seed = randi()
	noise.frequency = 2.0 
	
	shake_intensity = intensity
	active_shake_time = time
	shake_time = 0.0
