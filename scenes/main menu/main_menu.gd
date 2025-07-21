extends Node

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	# plays the main scene



func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main menu/options.tscn")
	# opens the options menu (not yet completed)


func _on_quit_pressed() -> void:
	get_tree().quit()
	# exits the game
	



func _on_survive_pressed() -> void:
	pass # put the code youll need to execute here :penguin:
	# plays survival scene (not yet made)
