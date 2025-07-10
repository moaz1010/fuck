extends HBoxContainer
 
@onready var slots = get_children()
signal index(i: int)
 
var current_index : int:
	set(value):
		current_index = value
		reset_focus()
		set_focus()
 
func _ready():
	current_index = 0
 
func reset_focus():
	for slot in slots:
		slot.set_process_input(false)
 
func set_focus():
	get_child(current_index).grab_focus()
	get_child(current_index).set_process_input(true)
	index.emit(current_index)
 
func _input(event):
	if event.is_action_pressed("ui_text_scroll_down"):
		if current_index == get_child_count() - 1:
			current_index = 0
		else:
			current_index += 1
 
	if event.is_action_pressed("ui_text_scroll_up"):
		if current_index == 0:
			current_index = get_child_count() - 1
		else:
			current_index -= 1
 
func add_item(stats, skill):
	for slot in slots:
		if slot.stats == null:
			slot.stats = stats
			slot.skill = skill
			return
