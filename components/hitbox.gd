extends Area2D
class_name HitBox

@export var damage : float

enum Types {
	ONE_SHOT,
	PROLONGED
}
@export var type: Types
@export var one_target: bool = false
var areas_hit: int = 0

func custom_behaviour():
	pass
