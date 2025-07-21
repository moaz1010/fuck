extends Node

var items: Array[InvWeaponResource] = []
signal added_weapon(weapon: InvWeaponResource)

func add_item(resource: InvWeaponResource):
	items.append(resource)
	added_weapon.emit(resource)
