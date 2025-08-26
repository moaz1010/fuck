extends Node

signal activated_flag(flag: flags_enum)

enum flags_enum {
	REACHED_DEAD_END,
	ENTERED_ENEMY_SPAWN_AREA,
	REACHED_FIRST_PARKOUR,
	REACHED_BORIS_IN_CAGE,
	GOT_BORIS_CAGE_KEY
}


var _flags : Dictionary[int, bool] = {}

func _init() -> void:
	for flag in flags_enum:
		_flags[flags_enum[flag]] = false

func get_flag(flag: flags_enum) -> bool:
	return _flags[flag]

func set_flag(flag: flags_enum, value: bool) -> void:
	_flags.set(flag, value)
	if value: activated_flag.emit(flag)

func activate_flag(flag: flags_enum) -> void:
	set_flag(flag, true)
