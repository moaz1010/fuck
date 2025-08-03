extends Area2D
class_name HurtBox

signal started_invisibility
signal stopped_invisibility

@export var health_component : HealthComponent
@export var invisibility_time : float = 0.5

var invisibility_timer : SceneTreeTimer
var is_invisible: bool = false:
	set(value):
		is_invisible = value
		if value: 
			started_invisibility.emit()
			invisibility_timer = get_tree().create_timer(invisibility_time)
			_set_up_invisibility_timer()
		else: stopped_invisibility.emit()

func _set_up_invisibility_timer() -> void:
	invisibility_timer.timeout.connect(
		func(): is_invisible = false
	)

func _process(delta: float) -> void:
	for area in get_overlapping_areas():
		if area is HitBox and not is_invisible:
			_consider_hitbox(area, delta)



func _consider_hitbox(hitbox: HitBox, delta: float = 1):
	var type := hitbox.type
	
	if type == HitBox.Types.ONE_SHOT:
		if hitbox.is_queued_for_deletion(): return
	
	if type == HitBox.Types.PROLONGED:
		if health_component:
			health_component.health -= hitbox.damage * delta
	else:
		if health_component:
			health_component.health -= hitbox.damage
		is_invisible = true
	
	if type == HitBox.Types.ONE_SHOT:
		hitbox.queue_free()
