extends Node2D


@onready var light : Area2D = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _process(_delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("fire"):
		print("akjfhdkf")
		light.visible = !light.visible
		light.monitoring = !light.monitoring


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
