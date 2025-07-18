extends MovingEntity

var to_be_followed : Array[Node2D]

var player_direction : Vector2

@onready var HealthComponent := %HealthComponent

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
	elif direction < 0:
		$Sprite2D.flip_h = true
		
	super(delta)

func take_damage(damage: float):
	HealthComponent.health -= damage
	print(HealthComponent.health)
func push(direction: Vector2, power: float = 1):
	velocity += direction * power

func _on_enter_area_body_entered(body: Node2D) -> void:
	if to_be_followed.is_empty():
		push(Vector2.LEFT * sign(_get_direction(body).x), 130)
	if to_be_followed.has(body): return
	to_be_followed.append(body)


#func _on_exit_area_body_entered(body: Node2D) -> void:
	#if body == player_node:
		#should_chase = false


func _on_exit_area_body_exited(body: Node2D) -> void:
	var index = to_be_followed.find(body)
	if index >= 0: to_be_followed.remove_at(index)


func _on_death() -> void:
	queue_free()
