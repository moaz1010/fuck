extends Control

@export var close_settings_menu_button: Button

func _process(_delta: float) -> void:                  # to update the button every press/hover for animation
	update_button_scale()

func update_button_scale():        
	button_hov(button, 1.3, 0.2)
	
	
func button_hov(button: Button, tween_amt, duration):   # to check wether the button is hovered or not
	button.pivot_offset = button.size / 2
	if button.is_hovered():
		tween(button, "scale", Vector2.ONE * tween_amt, duration)
	else:
		tween(button, "scale", Vector2.ONE, duration)
		
		
func tween(button, property, amount, duration):            # to get the animation properties
	create_tween().tween_property(button, property, amount, duration)
