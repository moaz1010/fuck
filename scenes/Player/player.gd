extends MovingEntity   # thank you

@onready var coyote_timer := %CoyoteTimer
@onready var jump_buffer := %JumpBuffer
@onready var weapon_shell := %WeaponShell
@onready var dash_timer := %DashTimer
@onready var dash_buffer := %DashBuffer
@onready var push_buffer := %PushBuffer

@onready var health = %HealthComponent
@onready var progress_bar := %ProgressBar

@export var DASH_POWER := 300.0


var current_look_dir := "right"

var can_slash := true
@export var slash_time := 0.2
@export var sword_return_time := 0.5
@export var weapon_damage := 1.0


var checkpoint_position: Vector2            # for the checkPoint System
var is_dead: bool = false

var was_on_floor: bool = true
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
	super()
	Inventory.added_weapon.connect(
		#This is here because the "change_weapon" function takes a scene
		#but the signal sends a resource.
		#It also calls calls the "change_weapon" function as deffered.
		func(resource: InvWeaponResource): 
			change_weapon.call_deferred(resource.weapon_scene)
	)
	Dialogue.entered_dialogue.connect(func(): can_move = false)
	Dialogue.exited_dialogue.connect(func(): can_move = true)
	
	checkpoint_position = global_position     # to save the position of checkpoint
	

func _unhandled_input(_event: InputEvent) -> void:
	#The character moves based on this variable, so when it is positive it
	#moves right, and when it is negative it moves left. / but why though ?
	direction = Input.get_axis("move_left", "move_right")

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
			dash(dash_direction, DASH_POWER)
			is_dashing = true
			dash_buffer.start()
			can_dash = false


func _process(_delta: float) -> void:
	
	if is_on_floor() and dash_buffer.is_stopped(): can_dash = true
	
	if not is_on_floor() and was_on_floor:
		coyote_timer.start()
	
	was_on_floor = is_on_floor()
	
	# to get the approriate animation for where the player looks
	
	if current_look_dir == "right" and get_global_mouse_position().x < global_position.x:
		$Sprite2D/AnimationPlayer.play("look_left")
		current_look_dir = "left"
	elif current_look_dir == "left" and get_global_mouse_position().x > global_position.x:
		$Sprite2D/AnimationPlayer.play("look_right")
		current_look_dir = "right"
		
		# the attack itself
		
	if Input.is_action_pressed("fire") and can_slash:
		$WeaponShell/Sprite2D/AnimationPlayer.speed_scale = $WeaponShell/Sprite2D/AnimationPlayer.get_animation("slash").length / slash_time
		$WeaponShell/Sprite2D/AnimationPlayer.play("slash")
		can_slash = false
		
	
	

func spawn_slash():
	pass

func _physics_process(delta: float) -> void:
	if wants_to_jump:
		if is_on_floor() or !coyote_timer.is_stopped(): 
			jump()
			if not push_buffer.is_stopped():
				velocity_increase.y += previous_push_velocity.y
			was_on_floor = false
			wants_to_jump = false
		coyote_timer.stop()

	#This executes the _physics_process method in the MovingEntity class
	#that handles all the movement shi.
	if can_move: super(delta)
	else: 
		direction = 0
		velocity = Vector2.ZERO


func change_weapon(scene: PackedScene) -> void:
	var instance := scene.instantiate()
	#This gets the root of the scene and shifts it a bit to the right.
	instance.position.x += 11
	#This removes all the nodes in the weapon shell to insure there are no 
	#weapons equipped and that they don't overlap.
	for child in weapon_shell.get_children(): child.visible = false
	weapon_shell.add_child(instance)


func _on_jump_buffer_timeout() -> void: wants_to_jump = false


func _on_weapon_shell_child_entered_tree(weapon: Node) -> void:
	if weapon is Gun:
		weapon.bullet_shot.connect(take_recoil)
func take_recoil(power):
	var recoil_direction = (
		global_position - weapon_shell.get_child(0).global_position).normalized()
	push(recoil_direction, power)


func _on_dash_timer_timeout() -> void: is_dashing = false


func _on_health_changed(new_health: float) -> void:
	progress_bar.value = new_health

func push(push_direction: Vector2, power: float = 1):
	super(push_direction, power)
	push_buffer.start()


func _on_checkpoint_activated(pos: Vector2) -> void:
	checkpoint_position = pos
	print("Checkpoint reached at: ", pos)


func _on_animation_player_2_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slash":
		$WeaponShell/Sprite2D/AnimationPlayer2.speed_scale = $WeaponShell/Sprite2D/AnimationPlayer2.get_animation("sword_return").length / sword_return_time
		$WeaponShell/Sprite2D/AnimationPlayer2.play("sword_return")
	else:
		can_slash = true
