extends MovingEntity   #yo can we like add comments next shit we add so that i can better understand the logic :pleading face:

@onready var coyote_timer := %CoyoteTimer
@onready var jump_buffer := %JumpBuffer
@onready var weapon_shell := %WeaponShell
@onready var dash_timer := %DashTimer
@onready var dash_buffer := %DashBuffer
@onready var health = %HealthComponent
@export var DASH_POWER := 300.0

var look_dir:String = "right"
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
	super()
	Inventory.added_weapon.connect(
		#This is here because the "change_weapon" function takes a scene
		#but the signal sends a resource.
		#It also calls calls the "change_weapon" function as deffered.
		func(resource: InvWeaponResource): 
			change_weapon.call_deferred(resource.weapon_scene)
	)

func _input(_event: InputEvent) -> void:

	#The character moves based on this variable, so when it is positive it
	#moves right, and when it is negative it moves left.
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

	if !can_move:
		return

	if is_on_floor() and dash_buffer.is_stopped(): can_dash = true

	if not is_on_floor() and was_on_floor:
		coyote_timer.start()

	was_on_floor = is_on_floor()


func _physics_process(delta: float) -> void:
	if wants_to_jump:
		if is_on_floor() or !coyote_timer.is_stopped(): 
			jump()
			was_on_floor = false
			wants_to_jump = false
		coyote_timer.stop()

	#This executes the _physics_process method in the MovingEntity class
	#that handles all the movement shi.
	super(delta)


func change_weapon(scene: PackedScene) -> void:
	var instance := scene.instantiate()
	#This gets the root of the scene and shifts it a bit to the right.
	instance.position.x += 11
	#This removes all the nodes in the weapon shell to insure there are no 
	#weapons equipped and that they don't overlap.
	for child in weapon_shell.get_children(): child.queue_free()
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
