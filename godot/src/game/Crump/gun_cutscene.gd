extends InteractComponent

enum CutsceneType{
	CRUMP,
	DOG,
}

@export var cutscene_to_play: CutsceneType

func _ready() -> void:
	print("activating cutscene link")
	super._ready()

func on_interacted():
	match cutscene_to_play:
		CutsceneType.CRUMP:
			Events.OnCrumpGunShot.emit()
		CutsceneType.DOG:
			Events.OnDogGunShot.emit()
	Globals.crump.speed *= muliply_trump_walk_speed
