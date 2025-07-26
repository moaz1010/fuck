extends CanvasLayer

@onready var text_label = %RichTextLabel

func _ready() -> void:
	Dialogue.entered_dialogue.connect(func(): show())
	Dialogue.continued_dialogue.connect(_on_continued_dialogue)
	Dialogue.exited_dialogue.connect(func(): hide())

func _on_continued_dialogue(section: DialogueResource) -> void:
	text_label.text = section.text
