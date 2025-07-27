extends Control

@onready var text_label := %RichTextLabel
@onready var speaker_texture := %TextureRect

var is_active: bool = false:
	set(value):
		is_active = value
		if value:
			show()
		else:
			text_label.text = ""
			speaker_texture.texture = null
			hide()

func _ready() -> void:
	Dialogue.entered_dialogue.connect(_initialize_box)
	Dialogue.continued_dialogue.connect(_on_continued_dialogue)
	Dialogue.exited_dialogue.connect(_reset_box)

func _input(_event: InputEvent) -> void:
	if is_active: 
		accept_event()
	if Input.is_action_just_pressed("ui_accept"):
		Dialogue.continue_dialogue()

func _on_continued_dialogue(section: DialogueResource) -> void:
	if section.text:
		text_label.text = section.text
	if section.speaker_sprite:
		speaker_texture.texture = section.speaker_sprite

func _initialize_box() -> void:
	is_active = true

func _reset_box():
	is_active = false
