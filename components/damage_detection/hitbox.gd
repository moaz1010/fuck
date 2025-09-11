extends Area2D
class_name HitBox

enum HitTypes {
	ONE_SHOT,
	PROLONGED
}

@export var damage : float
@export var type : Globals.HitboxTypes
@export var hit_type: HitTypes
@export var one_target: bool = false

var areas_hit: int = 0

func _ready() -> void:
	monitoring = false
