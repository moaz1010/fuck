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
		else:
			stopped_invisibility.emit()

func _set_up_invisibility_timer() -> void:
	invisibility_timer.timeout.connect(
		func(): 
			is_invisible = false
	)

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	for area in get_overlapping_areas():
		if area is HitBox:
			if area.type == HitBox.Types.PROLONGED: 
				_consider_hitbox(area, delta)

func _on_area_entered(area: Area2D):
	print("zam")
	if area is HitBox:
		print("holup")
		if area.type == HitBox.Types.ONE_SHOT:
			print("yay")
			_consider_hitbox(area)

func _consider_hitbox(hitbox: HitBox, delta: float = 1):
	
	if hitbox.is_queued_for_deletion(): return
	
	var type := hitbox.type
	
	if health_component:
		health_component.health -= hitbox.damage * delta
	if not type == HitBox.Types.PROLONGED:
		is_invisible = true
