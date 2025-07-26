extends CanvasLayer

@onready var text_label = %RichTextLabel

func _ready() -> void:
	Dialogue.entered_dialouge.connect(func(): show())
	Dialogue.continued_dialouge.connect(_on_continued_dialogue)
	Dialogue.exited_dialouge.connect(func(): hide())

func _on_continued_dialogue(section: DialogueResource) -> void:
	text_label.text = section.text
