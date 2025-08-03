extends Area2D
class_name HitBox

@export var damage : float

enum Types {
	ONE_SHOT,
	PROLONGED,
	LASTING_ONE_SHOT
}
@export var type: Types

func custom_behaviour():
	pass
