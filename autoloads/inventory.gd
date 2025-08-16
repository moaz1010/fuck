extends Node

signal added_weapon(weapon: InvWeaponResource)
signal weapon_switched(weapon: InvWeaponResource)

var items: Array[InvWeaponResource] = []
var current_weapon : InvWeaponResource:
	set(value):
		current_weapon = value
		weapon_switched.emit(value)

func add_item(resource: InvWeaponResource):
	items.append(resource)
	added_weapon.emit(resource)
