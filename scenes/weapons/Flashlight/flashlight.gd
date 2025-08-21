extends Node2D


@onready var light : Area2D = $Area2D
@onready var collision : CollisionPolygon2D = %CollisionPolygon2D

var _is_active: bool = false:
	set(value):
		if value:
			#Turns on falshlight.
			light.visible = true
			collision.disabled = false
		else:
			#Turns off flashlight.
			light.visible = false
			collision.disabled = true

func _input(_event: InputEvent) -> void:
	_is_active = Input.is_action_pressed("fire")
