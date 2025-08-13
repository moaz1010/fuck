extends Camera2D

func _ready() -> void:
	Camera.offset_changed.connect(
		func(value): offset = value
		)
