@tool
extends Button

signal level_selected

@onready var label = %Label

@export var level_num = 1:
	set(value):
		level_num = value
		if label: label.text = str(value)
		
@export var locked = true:
	set(value):
		locked = value
		if value: level_locked()
		else: level_unlocked()

func level_locked() -> void:
	level_state(true)

func _ready() -> void: label.text = str(level_num)

func level_unlocked() -> void:
	level_state(false)
	

func level_state(value: bool) -> void:
	disabled = value
	$Label.visible = not value


func _on_pressed() -> void:
	level_selected.emit(level_num)
