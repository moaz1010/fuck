extends Area2D
class_name HurtBox

signal started_invisibility
signal stopped_invisibility

@export var health_component : HealthComponent
@export var invisibility_time : float = 0.5
@export var invisible_to : Array[Globals.HitboxTypes] = []

var invisibility_timer : SceneTreeTimer
var is_invisible: bool = false:
	set(value):
		is_invisible = value
		_disable_collisions(value)
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
			if area.hit_type == HitBox.HitTypes.PROLONGED: 
				_consider_hitbox(area, delta)

func _on_area_entered(area: Area2D):
	if area is HitBox:
		if area.hit_type == HitBox.HitTypes.ONE_SHOT:
			_consider_hitbox(area)

func _consider_hitbox(hitbox: HitBox, delta: float = 1):
	if invisible_to.has(hitbox.type): return
	if hitbox.one_target:
		if hitbox.areas_hit > 0:
			hitbox.queue_free()
			return
	
	hitbox.areas_hit += 1
	var type := hitbox.hit_type
	
	if health_component:
		health_component.health -= hitbox.damage * delta
	if not type == HitBox.HitTypes.PROLONGED:
		is_invisible = true

func _disable_collisions(value: bool = true):
	for child in get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			child.set_deferred('disabled', value)
