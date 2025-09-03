extends Resource
class_name DialogueResource

@export_multiline var text : String

@export var choices : Array[Choice] = []

@export var flag_to_activate : Flags.flags_enum = -1

@export var character : CharacterResource

@export_group("Override character attributes")
@export var speaker_sprite : Texture2D
@export var talking_sound : AudioStream
@export var talking_speed_in_milliseconds : float
