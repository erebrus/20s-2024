extends InteractComponent


@export var voice_line_to_play : AudioStream

func on_interacted():
	if voice_line_to_play == null:
		Logger.warn("No audiostream assigned")
		return
	Globals.crump.change_voice_line(voice_line_to_play)
	Logger.info("{x} changed crumps voice line to: {y}".format({"x": parent_interactable.interactable_name,"y": voice_line_to_play}))
	super.on_interacted()
