extends Node

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	



func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main menu/options.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
	



func _on_survive_pressed() -> void:
	pass # put the code youll need to execute here :penguin:
