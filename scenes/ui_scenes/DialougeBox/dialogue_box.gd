extends Control

@onready var text_label := %RichTextLabel
@onready var speaker_texture := %TextureRect

@onready var audio_stream_player := %AudioStreamPlayer
@onready var skipping_buffer := %SkippingBuffer

var is_typing: bool = false

@export var default_type_speed : float
@export var pitch_difference_modifier : float

var _current_text_id : int = 0
var current_section: DialogueResource

var wants_to_skip : bool = false

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
	is_active = false
	Dialogue.entered_dialogue.connect(_initialize_box)
	Dialogue.continued_dialogue.connect(_on_continued_dialogue)
	Dialogue.exited_dialogue.connect(_reset_box)

func _input(_event: InputEvent) -> void:
	if is_active: 
		accept_event()
	if Input.is_action_just_pressed("ui_accept"):
		if is_typing:
			wants_to_skip = true
			return
		if not skipping_buffer.is_stopped(): 
			return
		_current_text_id += 1
		wants_to_skip = false
		Dialogue.continue_dialogue()

func _on_continued_dialogue(section: DialogueResource) -> void:
	current_section = section
	if section.talking_sound:
		audio_stream_player.stream = section.talking_sound
	if section.text:
		var current_talking_speed := default_type_speed
		if section.talking_speed_in_milliseconds:
			current_talking_speed = section.talking_speed_in_milliseconds
		_type_text(section.text, current_talking_speed)
	if section.speaker_sprite:
		speaker_texture.texture = section.speaker_sprite

func _initialize_box() -> void:
	is_active = true
	text_label.text = ""

func _reset_box():
	is_active = false
	text_label.text = ""
	audio_stream_player.stream = null

func _type_text(text: String, type_speed: float = default_type_speed):
	const PUNCTUATION: Array[String] = ['.', ',', '!', '?', ';', ':']
	
	_current_text_id += 1
	var id := _current_text_id
	
	text_label.visible_characters = 0
	text_label.text = text
	
	is_typing = true
	
	var typing_buffer : SceneTreeTimer = null
	
	for i in text.length():
		if typing_buffer and not wants_to_skip: await typing_buffer.timeout
		if _current_text_id != id: 
			is_typing = false
			return
		
		var next_letter_is_punctuation: bool = false
		if i+1 < text.length():
			if text[i+1] in PUNCTUATION: next_letter_is_punctuation = true
		
		if text[i] in PUNCTUATION and not next_letter_is_punctuation: 
			typing_buffer = get_tree().create_timer(type_speed / 100)
			wants_to_skip = false
		elif wants_to_skip: 
			typing_buffer = null
		else:
			typing_buffer = get_tree().create_timer(type_speed / 1000)
		
		audio_stream_player.pitch_scale = pow(pitch_difference_modifier, randf_range(-1, 1))
		if audio_stream_player.stream: audio_stream_player.play()
		
		text_label.visible_characters += 1
	
	wants_to_skip = false
	skipping_buffer.start()
	is_typing = false
