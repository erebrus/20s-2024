extends InteractComponent


func _ready() -> void:
	print("activating cutscene link")
	super._ready()
	
func on_interacted():
	Events.OnCrumpGunShot.emit()
	Globals.crump.speed *= muliply_trump_walk_speed
