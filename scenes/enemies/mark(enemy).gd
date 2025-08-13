extends StaticBody2D

@export var player: PackedScene

func _ready() -> void:
	$AnimationPlayer.play("idle")



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$AnimationPlayer.play("alerted")
		


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$AnimationPlayer.play("idle")
