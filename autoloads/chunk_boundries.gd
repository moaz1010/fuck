extends Node

class Limit:
	var right: float
	var left: float
	var top: float
	var bottom: float
	func is_equal(value: Limit) -> bool:
		if(self.right == value.right
		and self.left == value.left
		and self.top == value.top
		and self.bottom == value.bottom):
			return true
		return false

signal limit_changed(limit: Limit)
var current_limit: Limit = Limit.new():
	set(value):
		if not value.is_equal(current_limit):
			current_limit = value
			limit_changed.emit(current_limit)
		current_limit = value

var chunk_queue: Array[ChunkRoom] = []

func _ready() -> void:
	current_limit.right = 0
	current_limit.left = 0
	current_limit.top = 0
	current_limit.bottom = 0

func add_chunk(chunk: ChunkRoom) -> void:
	chunk_queue.append(chunk)
	if not chunk_queue.is_empty():
		current_limit = get_limit_from_chunk(chunk_queue[0])

func remove_chunk(chunk: ChunkRoom) -> void:
	var index = chunk_queue.find(chunk)
	chunk_queue.remove_at(index)
	if not chunk_queue.is_empty():
		current_limit = get_limit_from_chunk(chunk_queue[0])

func get_limit_from_chunk(chunk: ChunkRoom) -> Limit:
	var new_limit := Limit.new()
	new_limit.right = chunk.limit.right
	new_limit.left = chunk.limit.left
	new_limit.top = chunk.limit.top
	new_limit.bottom = chunk.limit.bottom
	return new_limit
