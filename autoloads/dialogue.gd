extends Node

signal entered_dialouge
signal exited_dialouge

signal continued_dialouge(section: DialogueResource)

var is_in_dialouge = false
var current_sections : Array[DialogueResource]
var current_section_index : int

func get_current_section():
	if current_section_index < 0 or current_section_index > current_sections.size():
		assert("Trying to access an item that doesn't exist inside dialouge array.")
	return current_sections[current_section_index]

func enter_dialogue(sections: Array[DialogueResource]):
	current_sections = sections
	current_section_index = 0
	if not is_in_dialouge: entered_dialouge.emit()
	is_in_dialouge = true
	continued_dialouge.emit(get_current_section())

func continue_dialogue(choice_index: int = -1):
	if not is_in_dialouge: return
	current_section_index += 1
	if current_section_index > current_sections.size(): 
		exit_dialogue()
		return
	continued_dialouge.emit(get_current_section())

func exit_dialogue():
	current_sections = []
	current_section_index = -1
	is_in_dialouge = false
	exited_dialouge.emit()
