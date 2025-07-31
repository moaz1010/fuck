@tool
extends Area2D
 
var sprite : Sprite2D
@export var weapon : InvWeaponResource: 
	set(value):
		weapon = value
		if weapon and sprite: sprite.texture = weapon.sprite  

func _ready() -> void:
	sprite = %Sprite
	if weapon and sprite: sprite.texture = weapon.sprite  #sets the texture

func _on_player_entered(_body: Node2D) -> void:
	if weapon: Inventory.add_item(weapon) # to make the weopon dissappear on pick up 
	queue_free()
