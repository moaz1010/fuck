extends CenterContainer



func _ready() -> void:
	$AnimationPlayer.play("appear")
	


func _on_give_up_button_pressed() -> void:
	$"../giveUpScreenContainer/AnimationPlayer".play("opened")


func _on_try_again_button_pressed() -> void:
	pass # yo keep it like this till we add levels and shi
