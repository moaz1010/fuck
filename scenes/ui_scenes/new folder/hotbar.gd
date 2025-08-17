extends Control
 
var slots : Array[Node]

var is_open := false

var selected_index: int = 0


var open_buttons: Array

@export var open_and_close_button: Button

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# Scroll up
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_scroll_hotbar(-1)
		# Scroll down
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_scroll_hotbar(1)


func _scroll_hotbar(direction: int) -> void:
	if slots.size() == 0:
		return
	
	selected_index = (selected_index + direction) % slots.size()
	if selected_index < 0:
		selected_index = slots.size() - 1

	slots[selected_index].button_pressed = true
	slots[selected_index].pressed.emit()
	#_switch_weapon(selected_index)
	#print("Scroll detected:", direction, " -> new index:", selected_index)
	#_highlight_slot(selected_index)

func _highlight_slot(index: int) -> void:
	for i in slots.size():
		slots[i].button_pressed = (i == index)  # only selected slot stays pressed



func _process(delta: float) -> void:
	update_button_scale()
	
	if Input.is_action_just_pressed("open_hotbar") and !is_open:
		$AnimationPlayer.play("open_full_hotbar")
		is_open = true

		

func _ready() -> void:
	open_buttons = [open_and_close_button]
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


func _on_toggle_menu_button_pressed() -> void:
	if !is_open:
		$AnimationPlayer.play("open_full_hotbar")
		is_open = true
	else:
		$AnimationPlayer.play("close_hotbar")
		is_open = false
		
		
		
func update_button_scale():                           # to actually animate button
	for button in open_buttons:
		button_hov(button, 1.7, 0.2)

func button_hov(button: Button, tween_amt, duration):   # to check wether the button is hovered or not
	button.pivot_offset = button.size / 2
	if button.is_hovered():
		tween(button, "scale", Vector2.ONE * tween_amt, duration)
	else:
		tween(button, "scale", Vector2.ONE, duration)

func tween(button, property, amount, duration):            # to get the animation properties
	create_tween().tween_property(button, property, amount, duration)
