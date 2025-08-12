extends Node
class_name CursorComponent

enum Hotspots {
	TOP_LEFT,
	CENTER
}

@export var image : Texture2D
@export var hotspot : Hotspots
@export var shape : Input.CursorShape

var hotspot_position : Vector2 = Vector2.ZERO


func _ready() -> void:
	if hotspot == Hotspots.CENTER:
		hotspot_position = image.get_size()/2
	change_cursor()

func change_cursor() -> void:
	Input.set_custom_mouse_cursor(image, shape, hotspot_position)
