extends MovingEntity   #yo can we like add comments next shit we add so that i can better understand the logic :pleading face:

@onready var coyote_timer := %CoyoteTimer
@onready var jump_buffer := %JumpBuffer
@onready var weapon_shell := %WeaponShell
@onready var dash_timer := %DashTimer

@export var DASH_POWER := 400.0

var was_on_floor: bool = true
var wants_to_jump: bool = false
var can_dash: bool = true

func _ready() -> void:
	super()
	Inventory.added_weapon.connect(
		#This is here because the "change_weapon" function takes a scene
		#but the signal sends a resource.
		func(resource: InvWeaponResource): 
			change_weapon.call_deferred(resource.weapon_scene)
	)

func _input(_event: InputEvent) -> void:

	direction = Input.get_axis("move_left", "move_right")

	if Input.is_action_just_pressed("move_up"):
		wants_to_jump = true
		jump_buffer.start()

	if Input.is_action_just_pressed("dash") and can_dash: 
		var dash_direction = Input.get_vector	("move_left",
											  "move_right", 
											  "move_up", 
											  "move_down")
		
		dash_timer.start()
		dash(dash_direction, DASH_POWER)
		can_dash = false


func _process(_delta: float) -> void:

	if is_on_floor(): can_dash = true

	if not is_on_floor() and was_on_floor:
		coyote_timer.start()
	was_on_floor = is_on_floor()

	if jump_buffer.is_stopped(): wants_to_jump = false

func _physics_process(delta: float) -> void:
	if wants_to_jump:
		if is_on_floor() or !coyote_timer.is_stopped(): 
			jump()
			was_on_floor = false
			wants_to_jump = false
		coyote_timer.stop()

	dash_percentage = dash_timer.time_left / dash_timer.wait_time

	super(delta)


func change_weapon(scene: PackedScene):
	var instance := scene.instantiate()
	instance.get_child(0).position.x += 11
	for child in weapon_shell.get_children(): child.queue_free()
	weapon_shell.add_child(instance)
