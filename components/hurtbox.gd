extends Area2D
class_name HurtBox

@export var health_component : HealthComponent

func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D):
	if area is HitBox:
		_on_hit(area)

func _on_hit(hitbox: HitBox):
	if hitbox.one_shot:
		if hitbox.is_queued_for_deletion(): return
		hitbox.queue_free()
	if health_component:
		health_component.health -= hitbox.damage
