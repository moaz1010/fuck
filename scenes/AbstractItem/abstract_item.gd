extends Sprite2D
 
@onready var collision = $Area2D/CollisionShape2D

 
func _on_player_entered(body: Node2D) -> void:
	call_deferred("reparent",body.find_child("Weapons"))
	position = body.position
	collision.call_deferred("set_disabled",true)
