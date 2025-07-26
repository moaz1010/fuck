extends Node
class_name HealthComponent


signal died
signal health_changed(new_health: float)

var previous_health: float = 0
@export var idle_healing: float = 0

@export var max_health: float
var min_health := 0.0
@onready var health: float = max_health:
	set(value):
		
		if value > max_health: 
			health = max_health
		else: 
			health = value
		
		if value <= min_health:
			died.emit()
		else:
			health_changed.emit(health)


func _process(delta: float) -> void:
	if health >= previous_health: 
		health += idle_healing * delta
	previous_health = health
