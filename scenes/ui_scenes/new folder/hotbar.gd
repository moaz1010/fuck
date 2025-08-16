extends Control

var slots : Array[Node]

func _ready() -> void:
	slots = %HBoxContainer.get_children().filter(
		func(child: Node) -> bool:
		return child is Button
		)
	for i in slots.size():
		slots[i].pressed.connect(
			func(): _switch_weapon(i)
				)
	Inventory.added_weapon.connect(
		func(_resource): _update_slots()
		)


func _update_slots() -> void:
	var index: int = 0
	for resource in Inventory.items:
		if index < slots.size(): 
			slots[index].icon = resource.sprite
		index += 1

func _switch_weapon(button_index: int) -> void:
	if Inventory.items.size() > button_index and button_index >= 0:
		Inventory.current_weapon = Inventory.items[button_index]
