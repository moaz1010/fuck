extends ProgressBar

var parent 



func _process(_delta: float) -> void:
	if value != max_value:
		self.visible = true
		if value == min_value:
			self.visible = false
	else:
		self.visible = false
