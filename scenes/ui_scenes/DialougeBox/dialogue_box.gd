extends Control

@onready var text_label := %RichTextLabel
@onready var speaker_texture := %TextureRect
@onready var audio_stream_player := %AudioStreamPlayer

var typing_buffer : SceneTreeTimer

@export var type_speed : float

var _desired_text : String

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
	if section.talking_sound:
		audio_stream_player.stream = section.talking_sound
	if section.text:
		_type_text(section.text)
	if section.speaker_sprite:
		speaker_texture.texture = section.speaker_sprite

func _initialize_box() -> void:
	is_active = true
	text_label.text = ""

func _reset_box():
	is_active = false
	text_label.text = ""

func _type_text(text: String):
	_desired_text = text
	var current_text := ""
	if typing_buffer: typing_buffer.set_time_left(0)
	for i in text.length():
		typing_buffer = get_tree().create_timer(type_speed)
		await typing_buffer.timeout
		if _desired_text != text: return
		current_text += text[i]
		if audio_stream_player.stream: audio_stream_player.play()
		text_label.text = current_text
