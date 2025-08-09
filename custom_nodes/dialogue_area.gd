@tool
extends Area2D
class_name DialogueArea

@export var defalut_dialogue : DialogueSection
@export var dialogue_sections: Array[FlaggedDialogueSection]

@export var is_instant : bool = false

var player_is_in_area: bool = false:
	set(value):
		player_is_in_area = value
		print(value)

func _unhandled_input(_event: InputEvent) -> void:
	if player_is_in_area and Input.is_action_just_pressed("accept_dialogue"):
		_trigger()

func _ready() -> void:
	collision_layer = 0
	collision_mask = 1
	self.body_entered.connect(_on_player_entered)
	self.body_exited.connect(_on_player_exited)

func _on_player_entered(_body: Node2D):
	player_is_in_area = true
	if is_instant: 
		_trigger()
	
func _on_player_exited(_body: Node2D):
	player_is_in_area = false

func _trigger() -> void:
	var final_section : DialogueSection = null
	if FlaggedDialogueSection:
		for section in dialogue_sections:
			if Flags.get_flag(section.flag):
				final_section = section
	if not final_section: final_section = defalut_dialogue
	Dialogue.enter_dialogue(final_section.dialogues)
