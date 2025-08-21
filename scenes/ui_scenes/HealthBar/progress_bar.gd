extends ProgressBar

@export var health_component : HealthComponent

func _ready():
	if health_component:
		health_component.health_changed.connect(_on_health_changed)

func _process(_delta: float) -> void:
	if value != max_value:
		self.visible = true
		if value == min_value:
			self.visible = false
	else:
		self.visible = false

func _on_health_changed(new_health: float) -> void:
	value = new_health
