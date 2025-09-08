extends Node2D
class_name ChunkTree

var chunks : Array[Chunk] = []

func _ready() -> void:
	for child in get_children():
		if child is Chunk: 
			var index: int = chunks.size()
			child.activation_changed.connect(
				func(_value):
					for chunk in get_surrounding_chunks(index):
						_update_chunk(chunk)
			)
			chunks.append(child)
	_update_all()

func _update_all(surround: int = 1) -> void:
	for chunk in chunks:
		_update_chunk(chunk, surround)

func _should_be_loaded(chunk: Chunk, surround: int = 1) -> bool:
	var index := chunks.find(chunk)
	if index < 0: return false
	
	for i in get_surrounding_chunks(index, surround):
		if i.is_active:
			return true
	
	return false

func _update_chunk(chunk: Chunk, surround: int = 1) -> void:
	if _should_be_loaded(chunk, surround):
		if not chunk.is_inside_tree():
			add_child.call_deferred(chunk)
			print("add", chunk)
	elif chunk.is_inside_tree():
			remove_child.call_deferred(chunk)
			print("remove", chunk)

func get_surrounding_chunks(index: int, surround:int = 1) -> Array[Chunk]:
	var result : Array[Chunk] = []
	
	var surround_range := range(index-surround, index+surround+1)
	for i in surround_range:
		if i >= 0 and i < chunks.size():
			result.append(chunks[i])
	
	return result
