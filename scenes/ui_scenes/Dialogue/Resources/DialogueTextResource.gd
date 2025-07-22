extends DE
class_name DialogueText

@export var speaker_name: String
@export var speaker_img: Texture
@export var speaker_img_Hframes: int = 1                    # yea i dont even know what all of that is 
@export var speaker_img_rest_frame: int = 0

@export_multiline var text: String
@export_range(0.1, 30.0, 0.1) var text_speed: float = 1.0

@export var text_sound: AudioStream
@export var text_volume_db: int
@export var text_volume_pitch_min: float = 0.85
@export var text_volume_pitch_max: float = 1.15

@export var camera_position: Vector2 = Vector2(999.999, 999.999)           # especially this
@export_range(0.05, 10.0, 0.05) var camera_transition: float = 1.0
