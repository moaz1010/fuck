extends CharacterBody2D

const SPEED = 200

func _physics_process(_delta):
	
	var direction = Input.get_vector("move_keft", "move_right", "move_up", "move_down")

	velocity = direction.normalized() * SPEED
	move_and_slide()
