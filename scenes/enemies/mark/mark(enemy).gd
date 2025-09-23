extends StaticBody2D

@export var player: PackedScene

@onready var health_component := %HealthComponent
@onready var progress_bar := %ProgressBar

func _ready() -> void:
	$AnimationPlayer.play("idle")



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$AnimationPlayer.play("alerted")
		


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$AnimationPlayer.play("idle")

func _on_health_changed(new_health: float) -> void:
	var offset: float = health_component.max_health * .5
	var value = (new_health+offset) / (health_component.max_health+offset)
	modulate.b = clamp(value,0 , 1)
	modulate.g = clamp(value, 0, 1)
	$AnimationPlayer.play("getting_hit")


func _on_death() -> void:
	queue_free()
