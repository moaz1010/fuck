extends Sprite2D
 
@onready var collision = $Area2D/CollisionShape2D
@export var weapon : InvWeaponResource: 
	set(value):
		weapon = value
		if weapon: texture = weapon.sprite  

func _ready() -> void:
	if weapon: texture = weapon.sprite  #sets the texture

func _on_player_entered(_body: Node2D) -> void:
	if weapon: Inventory.add_item(weapon) # to make the weopon dissappear on pick up 
	queue_free()
