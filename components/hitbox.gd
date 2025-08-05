extends Area2D
class_name HitBox

@export var damage : float

enum Types {
	ONE_SHOT,
	PROLONGED
}
@export var type: Types

func custom_behaviour():
	pass
