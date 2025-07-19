extends Node2D
 
var current_index: int = 0
 
func reset():
	var weapons = get_children()
	for weapon in weapons:
		weapon.hide()
 
func show_weapon(index):
	if index < get_child_count():
		get_child(index).show()
 
 
func _on_index(i = current_index):
	reset()
	show_weapon(i)
	current_index = i
 
 
func _on_child_entered_tree(_node: Node) -> void:
	_on_index()
