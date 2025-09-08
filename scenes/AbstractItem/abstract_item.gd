@tool
extends Area2D
 
var sprite : Sprite2D
@export var weapon : InvWeaponResource: 
	set(value):
		weapon = value
		if weapon and sprite: sprite.texture = weapon.sprite  

func _ready() -> void:
	sprite = %Sprite
	if sprite:
		if weapon: sprite.texture = weapon.sprite  #sets the texture
		if get_children().filter(func(child): return child is CollisionShape2D):
			return
		var collision_shape := CollisionShape2D.new()
		var rect := sprite.get_rect()
		
		collision_shape.position = rect.position + rect.size/2
		
		var rectangle := RectangleShape2D.new()
		rectangle.size = rect.size
		
		collision_shape.shape = rectangle
		
		add_child(collision_shape)

func _on_player_entered(_body: Node2D) -> void:
	if weapon: Inventory.add_item(weapon) # to make the weopon dissappear on pick up 
	queue_free()
