extends Node

signal activated_flag(flag: flags_enum)

enum flags_enum {
	REACHED_DEAD_END
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
