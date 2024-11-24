class_name TimeDisplay
extends Label

var currentTime := 0.0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	currentTime += delta
	text = str( roundi(currentTime))
