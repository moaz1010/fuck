extends Node2D
class_name Chunk

signal activation_changed(value: bool)

@export var is_active : bool = false:
	set(value):
		if value != is_active:
			is_active = value
			activation_changed.emit(is_active)
		is_active = value
