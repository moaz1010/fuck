extends MovingEntity

var to_be_followed : Array[Node2D]

var player_direction : Vector2

@onready var health_component := %HealthComponent

func _ready() -> void:
	add_to_group("enemy")

func _get_direction(body: Node2D) -> Vector2:
	return (body.global_position-global_position).normalized()

func _physics_process(delta: float) -> void:
	if not to_be_followed.is_empty(): 
		player_direction = _get_direction(to_be_followed[0])
		direction = sign(player_direction.x)
	else: direction = 0
	#velocity = lerp(velocity, direction * speed, 8.5 * delta )
	
	if direction > 0:
		$Sprite2D.flip_h = false
		$Sprite2D.play("move")
	elif direction < 0:
		$Sprite2D.flip_h = true
		$Sprite2D.play("move")
		
	super(delta)


func _on_enter_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if to_be_followed.is_empty():
			push(Vector2.LEFT * sign(_get_direction(body).x), 130)
		if to_be_followed.has(body): return
		to_be_followed.append(body)


#func _on_exit_area_body_entered(body: Node2D) -> void:
	#if body == player_node:
		#should_chase = false


func _on_exit_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		var index = to_be_followed.find(body)
		if index >= 0: to_be_followed.remove_at(index)


func _on_death() -> void:
	queue_free()


func _on_health_changed(new_health: float) -> void:
	var offset: float = health_component.max_health * .5
	var value = (new_health+offset) / (health_component.max_health+offset)
	modulate.b = clamp(value,0 , 1)
	modulate.g = clamp(value, 0, 1)
