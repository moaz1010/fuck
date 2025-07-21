extends Sprite2D
 
@onready var collision = $Area2D/CollisionShape2D
@export var weapon : InvWeaponResource

func _ready() -> void:
	if weapon: texture = weapon.sprite  #sets the texture

func _on_player_entered(body: Node2D) -> void:
	if weapon: GlobalSignals.add_item_to_inventory.emit(weapon)  # to make the weopon dissappear on pick up 
	queue_free()
