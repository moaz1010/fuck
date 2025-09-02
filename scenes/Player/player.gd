extends CharacterBody2D   # :penguin:

@onready var coyote_timer := %CoyoteTimer
@onready var jump_buffer := %JumpBuffer
@onready var weapon_shell := %WeaponShell
@onready var dash_timer := %DashTimer
@onready var dash_buffer := %DashBuffer
@onready var push_buffer := %PushBuffer

@onready var health = %HealthComponent
@onready var progress_bar := %ProgressBar
@onready var platformer_component := %PlatformerComponent
@export var DASH_POWER := 300.0

var current_look_dir := "right"

var checkpoint_position: Vector2     
var previous_push_velocity: Vector2 = Vector2.ZERO       # for the checkPoint System

var is_dead: bool = false
var was_able_to_jump: bool = true
var wants_to_jump: bool = false
var can_dash: bool = true:
	set(value):
		can_dash = value
		if not value: modulate = Color(.5, .5, 1.0)
		else: modulate = Color.WHITE
var can_move: bool = true

func _ready() -> void:
	dash_buffer.wait_time += dash_timer.wait_time
	add_to_group("player")
	progress_bar.min_value = health.min_health
	progress_bar.max_value = health.max_health
	Inventory.weapon_switched.connect(
		#This is here because the "change_weapon" function takes a scene
		#but the signal sends a resource.
		#It also calls calls the "change_weapon" function as deffered.
		func(resource: InvWeaponResource): 
			change_weapon.call_deferred(resource.weapon_scene)
	)
	Dialogue.entered_dialogue.connect(func(): can_move = false)
	Dialogue.exited_dialogue.connect(func(): can_move = true)
	
	
	if CheckpointAutoload.checkpoint_pos != Vector2(-999, -999):  # to make the player respawn a
		global_position = CheckpointAutoload.global_position      # the checkpoint
	
	

func _unhandled_input(_event: InputEvent) -> void:
	#The character moves based on this variable, so when it is positive it
	#moves right, and when it is negative it moves left. / but why though ?
	platformer_component.lock_movement = Input.is_action_pressed("lock_movement")
	platformer_component.direction = Input.get_axis("move_left", "move_right")

	if Input.is_action_just_pressed("move_up"):
		wants_to_jump = true
		#The player is assumed to always want to jump until the jump buffer stops.
		jump_buffer.start()

	if Input.is_action_just_pressed("dash") and can_dash: 
		var dash_direction = Input.get_vector(
			"move_left",
			"move_right", 
			"move_up", 
			"move_down"
		).normalized()
		
		#Only dash if the player isn't standing still.
		if not dash_direction == Vector2.ZERO:
			dash_timer.start()
			platformer_component.insta_push(dash_direction, 1000)
			#dash(dash_direction, DASH_POWER)
			#is_dashing = true
			dash_buffer.start()
			can_dash = false
			Camera.screen_shake(5,0.15)


func _process(_delta: float) -> void:

	if is_on_floor() and dash_buffer.is_stopped(): 
		can_dash = true
	
	if not (is_on_floor() or is_on_wall()) and was_able_to_jump:
		coyote_timer.start()
	
	was_able_to_jump = is_on_floor() or is_on_wall()
	
	# to get the approriate animation for where the player looks
	if current_look_dir == "right" and get_global_mouse_position().x < global_position.x:
		$Sprite2D/AnimationPlayer.play("look_left")
		current_look_dir = "left"
	elif current_look_dir == "left" and get_global_mouse_position().x > global_position.x:
		$Sprite2D/AnimationPlayer.play("look_right")
		current_look_dir = "right"


func _physics_process(delta: float) -> void:
	if wants_to_jump:
		if is_on_floor() or is_on_wall() or !coyote_timer.is_stopped(): 
			platformer_component.jump()
			if not push_buffer.is_stopped():
				platformer_component.velocity_increase.y += previous_push_velocity.y
			was_able_to_jump = false
			wants_to_jump = false
		coyote_timer.stop()

	#This executes the _physics_process method in the MovingEntity class
	#that handles all the movement shi.
	if can_move: 
		var is_considered_on_wall : bool = false
		if is_on_wall():
			for i in get_slide_collision_count():
				var collision = get_slide_collision(i)
				if collision.get_normal().x == -Input.get_axis("move_left", "move_right"):
					is_considered_on_wall = true
					
		velocity = platformer_component.calculate(delta, is_on_floor(), is_considered_on_wall)
		move_and_slide()
		platformer_component.velocity = velocity


func change_weapon(scene: PackedScene) -> void:
	var instance := scene.instantiate()
	#This gets the root of the scene and shifts it a bit to the right.
	instance.position.x += 11
	#This removes all the nodes in the weapon shell to insure there are no 
	#weapons equipped and that they don't overlap.
	for child in weapon_shell.get_children(): 
		child.queue_free()
	weapon_shell.add_child(instance)


func _on_jump_buffer_timeout() -> void: wants_to_jump = false


func _on_weapon_shell_child_entered_tree(weapon: Node) -> void:
	
	for child in weapon.get_children():
		if child is ShootComponent: 
			child.bullet_shot.connect(take_recoil)
		

func take_recoil(power):
	var recoil_direction = (
		global_position - weapon_shell.get_child(0).global_position).normalized()
	recoil_direction.y /= 1.5
	push(recoil_direction, power)


func _on_dash_timer_timeout() -> void: 
	#is_dashing = false
	pass


func push(push_direction: Vector2, power: float = 1):
	platformer_component.push(push_direction, power)
	previous_push_velocity = push_direction * power
	push_buffer.start()


func _on_checkpoint_activated(pos: Vector2) -> void:
	checkpoint_position = pos
	print("Checkpoint reached at: ", pos)


func _on_health_component_died() -> void:
	get_tree().change_scene_to_file.call_deferred("res://scenes/ui_scenes/death screen/death_screen.tscn")
	
