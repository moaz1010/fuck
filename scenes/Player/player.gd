extends MovingEntity   #yo can we like add comments next shit we add so that i can better understand the logic :pleading face:

@onready var coyote_timer := %CoyoteTimer
@onready var jump_buffer := %JumpBuffer
@onready var weapon_shell := %WeaponShell

var was_on_floor: bool = true
var wants_to_jump: bool = false
var can_move: bool = true

func _ready() -> void:
	add_to_group("player")
	super()
	Inventory.added_weapon.connect(
		func(resource: InvWeaponResource): 
			change_weapon.call_deferred(resource.weapon_scene)
	)

func _input(_event: InputEvent) -> void:

	if Input.is_action_just_pressed("move_up"):
		wants_to_jump = true
		jump_buffer.start()

	direction = Input.get_axis("move_left", "move_right")


func _process(_delta: float) -> void:
	if !can_move:
		return
	if not is_on_floor() and was_on_floor:
		coyote_timer.start()
	was_on_floor = is_on_floor()

	if jump_buffer.is_stopped(): wants_to_jump = false


	if wants_to_jump:
		if is_on_floor() or !coyote_timer.is_stopped(): 
			jump()
			was_on_floor = false
			wants_to_jump = false
		coyote_timer.stop()


func change_weapon(scene: PackedScene):
	var instance := scene.instantiate()
	instance.get_child(0).position.x += 11
	for child in weapon_shell.get_children(): child.queue_free()
	weapon_shell.add_child(instance)
