extends MarginContainer

@export var menu_screen: VBoxContainer
@export var open_menu_screen: VBoxContainer
@export var open_menu_button: Button
@export var close_menu_button: Button


func _process(delta: float) -> void:
	update_button_scale()

func update_button_scale():
	button_hov(open_menu_button, 1.5, 0.2)
	button_hov(close_menu_button, 1.5, 0.2)

func button_hov(button: Button, tween_amt, duration):
	button.pivot_offset = button.size / 2
	if button.is_hovered():
		tween(button, "scale", Vector2.ONE * tween_amt, duration)
	else:
		tween(button, "scale", Vector2.ONE, duration)

func tween(button, property, amount, duration):
	var tween = create_tween()
	tween.tween_property(button, property, amount, duration)

func toggle_visibility(object):
	if object.visible:
		object.visible = false 
	else:
		object.visible = true
		





func _on_toggle_menu_button_pressed() -> void:
	toggle_visibility(menu_screen)
	toggle_visibility(open_menu_screen)
	
