extends Camera2D

@onready var tilemap = get_parent().get_node("TileMapLayer")






# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if tilemap == null:	
		print("not found :pensive:")
		return
	var mapRect = tilemap.get_used_rect()
	var tileSize = tilemap.tile_set.tile_size
	var worldSizeInPixels = mapRect.size * tileSize
	limit_right = worldSizeInPixels.x
	limit_bottom = worldSizeInPixels.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
