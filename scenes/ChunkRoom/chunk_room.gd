extends Chunk

@onready var area2d := %Area2D

var stop_timer : bool = false

func _ready() -> void:
	for child in get_children():
		if child is TileMapLayer:
			var shape = _get_collision_shape(child)
			area2d.add_child(shape)


func _get_collision_shape(tile_map_layer: TileMapLayer) -> CollisionShape2D:
	var result = CollisionShape2D.new()
	
	var rectangle = RectangleShape2D.new()
	rectangle.size = _get_rect_size(tile_map_layer)
	
	result.shape = rectangle
	result.position = _get_rect_position(tile_map_layer)
	
	return result

func _get_rect_size(tile_map_layer: TileMapLayer) -> Vector2:
		var rect := tile_map_layer.get_used_rect()
		var tile_size := tile_map_layer.tile_set.tile_size
		return rect.size * tile_size

func _get_rect_position(tile_map_layer: TileMapLayer) -> Vector2:
		var rect = tile_map_layer.get_used_rect()
		var rect_size : Vector2 = rect.size/2.0
		var rect_position : Vector2 = rect.position
		var tile_size : Vector2 = tile_map_layer.tile_set.tile_size
		return (rect_position+rect_size) * tile_size


func _on_area_2d_body_entered(_body: Node2D) -> void:
	stop_timer = true
	is_active = true


func _on_area_2d_body_exited(_body: Node2D) -> void:
	stop_timer = false
	await get_tree().create_timer(1).timeout
	if stop_timer: return
	is_active = false
