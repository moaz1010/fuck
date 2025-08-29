extends Resource
class_name  Choice

@export var text : String
@export var flag : Flags.flags_enum = -1
@export var next_dialogue : Array[DialogueResource] = []
