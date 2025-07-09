extends Button

@onready var player = get_tree().current_scene.find_child("player")
 
@export var stats : Item = null:
	set(value):
		stats = value
	 
		if value != null:
				icon = value.icon
		else:
			icon = null
	 
@export var skill : Skill = null
 
func _ready():
	set_process_input(false)
 
func _input(event):
	if event.is_action_pressed("use"):
		use_item()

func use_item():
	if stats == null:
		return
	player.play_FX(skill)

  
func _on_pressed():
	use_item()
	get_parent().current_index = get_index()
	player.find_child("Weapons")._on_index(get_index())
