extends Camera2D

var _dragging := false
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pan_camera"):
		_dragging = true
	if event is InputEventMouseMotion:
		if _dragging:
			global_position -= event.relative / zoom

func _input(event: InputEvent) -> void:
	if event.is_action_released("pan_camera"):
		_dragging = false
