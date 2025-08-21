extends CharacterBody2D

var SPEED: int = 300
var ROTATION_SPEED: float = 3

@export var BULLET : PackedScene
var sprites : Array[Sprite2D]
@onready var sprites_node := %Sprites

func _ready() -> void:
	for sprite in sprites_node.get_children():
		sprites.append(sprite)

func _process(delta: float) -> void:
	sprites_node.rotate(ROTATION_SPEED*2*PI*delta)

func _physics_process(delta: float) -> void:
	velocity = Vector2.RIGHT*SPEED*delta
	velocity = velocity.rotated(global_rotation)
	var collision = move_and_collide(velocity)
	if collision:
		_split.call_deferred()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(_body: Node2D) -> void:
	_split.call_deferred()


func _on_area_entered(_area: Area2D) -> void:
	_split.call_deferred()

func _split():
	for sprite in sprites:
		var bullet_instance = BULLET.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = sprite.global_position
		bullet_instance.global_rotation = sprite.global_rotation
	queue_free()


func _on_split_timer_timeout() -> void:
	_split.call_deferred()
