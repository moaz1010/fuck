extends CharacterBody2D

const SPEED = 200
@onready var fx: AnimatedSprite2D = $FX
@onready var hotbar: HBoxContainer = $UI/Hotbar



func _physics_process(_delta):
	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	velocity = direction.normalized() * SPEED
	move_and_slide()




func play_FX(skill):
	fx.play(skill.name)
	

func add_item(stats,skill):
	hotbar.add_item(stats,skill)
