extends InteractComponent


@export var voice_line_to_play : AudioStream
@export var trigger: Types.EndingType

func on_interacted():
	if voice_line_to_play == null:
		Logger.warn("No audiostream assigned")
		return
	match trigger:
		Types.EndingType.WIN:
			Globals.crump.trigger_win(voice_line_to_play)
		Types.EndingType.LOSE:
			Globals.crump.trigger_lose(voice_line_to_play)

	Logger.info("{x} triggered game ending: {y}".format({"x": parent_interactable.interactable_name,"y": trigger}))
	super.on_interacted()
