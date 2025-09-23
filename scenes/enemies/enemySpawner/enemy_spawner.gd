extends Node2D

@export var enemy_prefab: PackedScene  # to get which enemy to spawn
@export var num_of_enemies: int       # to choose how many enemies spawn

func _ready():
	Flags.activated_flag.connect(_on_flag_activated)

func _on_flag_activated(flag):
	if flag == Flags.flags_enum.ENTERED_ENEMY_SPAWN_AREA:
		$Timer.start()
	
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Flags.activate_flag(Flags.flags_enum.ENTERED_ENEMY_SPAWN_AREA)
		
		
		

func _on_timer_timeout() -> void:
	var enemy = enemy_prefab.instantiate()
	add_child(enemy)
