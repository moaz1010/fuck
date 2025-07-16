extends Node
class_name HealthComponent

signal died

@export var health: float = 10.0:
	set(value):
		if value <= 0:
			died.emit()
		else: health = value
