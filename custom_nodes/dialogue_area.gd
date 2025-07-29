@tool
extends Area2D
class_name DialogueArea

@export var first_time_dialogue : Array[DialogueResource] = []
@export var repeat_dialogue : Array[DialogueResource] = []

var first_time: bool = true

func _ready() -> void:
	collision_layer = 0
	collision_mask = 1
	self.body_entered.connect(_on_player_entered)

func _on_player_entered(_body: Node2D):
	if first_time or not repeat_dialogue: 
		first_time = false
		Dialogue.enter_dialogue(first_time_dialogue)
	else: Dialogue.enter_dialogue(repeat_dialogue)
