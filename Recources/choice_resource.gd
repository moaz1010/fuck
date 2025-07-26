extends Resource
class_name  Choice

@export var text : String
@export var callable : Callable = func(): pass
@export var next_dialogue : Array[DialogueResource]
