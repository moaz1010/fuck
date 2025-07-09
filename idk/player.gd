extends MovingEntity

@onready var fx: AnimatedSprite2D = $FX
@onready var hotbar: HBoxContainer = $UI/Hotbar



func _process(delta: float):
	
	
	direction = Input.get_axis("move_left", "move_right")
	
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		jump()




func play_FX(skill):
	fx.play(skill.name)
	

func add_item(stats,skill):
	hotbar.add_item(stats,skill)
