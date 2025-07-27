@tool
extends Area2D
class_name DialogueArea

@export var dialogue : Array[DialogueResource] = []

func _ready() -> void:
	collision_layer = 0
	collision_mask = 1
	self.body_entered.connect(_on_player_entered)

func _on_player_entered(_body: Node2D):
	Dialogue.enter_dialogue(dialogue)
