extends Resource
class_name DialogueResource

@export_multiline var text : String

@export var speaker_sprite : Texture2D

@export var choices : Array[Choice] = []

@export var talking_sound : AudioStream

@export var talking_speed_in_milliseconds : float
