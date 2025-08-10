extends Node

signal entered_dialogue
signal exited_dialogue

signal continued_dialogue(section: DialogueResource)

var is_in_dialogue = false
var current_sections : Array[DialogueResource]
var current_section_index : int

func get_current_section() -> DialogueResource:
	assert(current_section_index >= 0 and current_section_index < current_sections.size(), 
	"Trying to access an item that doesn't exist inside dialouge array.")
	return current_sections[current_section_index]

func enter_dialogue(sections: Array[DialogueResource]):
	current_sections = sections
	current_section_index = 0
	if sections.is_empty(): 
		if is_in_dialogue: exited_dialogue.emit()
		return
	if not is_in_dialogue: entered_dialogue.emit()
	is_in_dialogue = true
	continued_dialogue.emit(get_current_section())

func continue_dialogue():
	if not is_in_dialogue: return
	current_section_index += 1
	if current_section_index >= current_sections.size(): 
		exit_dialogue()
		return
	continued_dialogue.emit(get_current_section())

func choose(index: int):
	var choices := get_current_section().choices
	
	assert(index >= 0 and index < choices.size(), 
	"Trying to choose a choice that doesn't exist")
	
	if choices[index].next_dialogue:
		enter_dialogue(choices[index].next_dialogue)
	if choices[index].flag:
		Flags.activate_flag(choices[index].flag)

func exit_dialogue():
	current_sections = []
	current_section_index = -1
	is_in_dialogue = false
	exited_dialogue.emit()
