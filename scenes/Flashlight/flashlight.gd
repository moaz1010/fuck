extends Node2D


@onready var light : Area2D = $Area2D

var nodes_in_area : Array[Node2D]
var damage := 1.0


func _process(delta):
	for body in nodes_in_area:
		if body.has_method("take_damage"):
			body.take_damage(damage * delta)


	if Input.is_action_pressed("fire"):
		#Turns on falshlight.
		light.visible = true
		light.monitoring = true
	else:
		#Turns off flashlight.
		light.visible = false
		light.monitoring = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not nodes_in_area.has(body): nodes_in_area.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	var index : int = nodes_in_area.find(body)
	if index >= 0:
		nodes_in_area.remove_at(index)
