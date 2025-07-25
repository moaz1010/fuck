extends MarginContainer

@export var menu_screen: VBoxContainer          # exporting all menus in the main one 
@export var open_menu_screen: VBoxContainer


@export var open_menu_button: Button            # exporting all buttons in the main menu for animation
@export var close_menu_button: Button
@export var open_pause_button: Button
@export var close_pause_button: Button 
@export var open_settings_menu_button: Button

@export var open_are_you_sure_menu_button: Button
@export var close_are_you_sure_menu_button: Button

var in_menu_buttons: Array                  # making arrays to group together certain buttons
var close_menu_buttons: Array
var toggle_popupmenu_buttons: Array

func _ready() -> void:                   # grouping them in the _ready function
	in_menu_buttons = [open_pause_button, open_settings_menu_button, open_are_you_sure_menu_button]
	toggle_popupmenu_buttons = [open_menu_button, close_menu_button]



func _process(_delta: float) -> void:                  # to update the button every press/hover for animation
	update_button_scale()

func update_button_scale():                           # to actually animate button
	for button in in_menu_buttons:
		button_hov(button, 1.3, 0.2)
	for button in toggle_popupmenu_buttons:
		button_hov(button, 1.6, 0.2)
	for button in close_menu_buttons:
		button_hov(button, 1.3, 0.2)
	
	

func button_hov(button: Button, tween_amt, duration):   # to check wether the button is hovered or not
	button.pivot_offset = button.size / 2
	if button.is_hovered():
		tween(button, "scale", Vector2.ONE * tween_amt, duration)
	else:
		tween(button, "scale", Vector2.ONE, duration)

func tween(button, property, amount, duration):            # to get the animation properties
	create_tween().tween_property(button, property, amount, duration)

func toggle_visibility(object):
	var anim = $AnimationPlayer
	var animation_type: String
							   
													# pretty self explanatory (atleast i hope)
	if object.visible:
		animation_type = "close_"
	else:
		animation_type = "open_"
	anim.play(animation_type + str(object.name))
	
	print(animation_type + str(object.name))
	



func _on_toggle_menu_button_pressed() -> void:
	toggle_visibility(open_menu_screen)
	


func _on_toggle_settings_menu_pressed() -> void:
	pass
