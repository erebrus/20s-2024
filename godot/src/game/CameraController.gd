extends Camera2D


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("pan_camera"):
			global_position -= event.relative / zoom
