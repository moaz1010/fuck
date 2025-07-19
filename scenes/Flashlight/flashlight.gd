extends Node2D


@onready var light : Area2D = $Area2D

var nodes_in_area : Array[Node2D]
var damage := 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _process(delta):
	look_at(get_global_mouse_position())
	
	for body in nodes_in_area:
		if body.has_method("take_damage"):
			body.take_damage(damage * delta)


	if Input.is_action_just_pressed("fire"):
		light.visible = !light.visible
		light.monitoring = !light.monitoring


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not nodes_in_area.has(body): nodes_in_area.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	var index : int = nodes_in_area.find(body)
	if index >= 0:
		nodes_in_area.remove_at(index)
