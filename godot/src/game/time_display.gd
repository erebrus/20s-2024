class_name TimeDisplay
extends Label

var currentTime := 0.0

func _ready():
	set_process(false)
	text = str( roundi(currentTime))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	currentTime += delta
	text = "%ds" % roundi(currentTime)
	if roundi(currentTime)==20:
		set_process(false)
