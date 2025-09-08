extends Chunk
class_name ChunkRoom

var area2d : Area2D

var stop_timer : bool = false
var limit : Dictionary[String, float] = {
	left = 10000000,
	top = 10000000,
	right = -10000000,
	bottom = -10000000,
}

func _ready() -> void:
	area2d = Area2D.new()
	area2d.collision_layer = 0
	area2d.collision_mask = 1
	area2d.body_entered.connect(_on_area_2d_body_entered)
	area2d.body_exited.connect(_on_area_2d_body_exited)
	add_child(area2d)
	for child in get_children():
		if child is TileMapLayer:
			var shape = _get_collision_shape(child)
			area2d.add_child(shape)
			_update_limit(child)


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

func _update_limit(tile_map_layer: TileMapLayer) -> void:
	var rect := tile_map_layer.get_used_rect()
	rect.position *= tile_map_layer.tile_set.tile_size
	rect.size *= tile_map_layer.tile_set.tile_size 
	
	if rect.position.x < limit.left:
		limit.left = rect.position.x
	if rect.position.y < limit.top:
		limit.top = rect.position.y
	if rect.end.x > limit.right:
		limit.right = rect.end.x
	if rect.end.y > limit.bottom:
		limit.bottom = rect.end.y

func _on_area_2d_body_entered(_body: Node2D) -> void:
	stop_timer = true
	is_active = true
	ChunkBoundries.add_chunk(self)


func _on_area_2d_body_exited(_body: Node2D) -> void:
	stop_timer = false
	ChunkBoundries.remove_chunk(self)
	await get_tree().create_timer(0.3).timeout
	if stop_timer: return
	is_active = false
