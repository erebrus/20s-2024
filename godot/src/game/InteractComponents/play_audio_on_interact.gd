extends InteractComponent


@export var audio_to_play : AudioStream
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	super._ready()
	if !audio_stream_player_2d:
		Logger.error("play_audio_on_interact needs an AudioSreamPlayer2D as child")

func on_interacted():
	if audio_to_play == null:
		Logger.warn("No audiostream assigned")
		return
	audio_stream_player_2d.stream =audio_to_play
	audio_stream_player_2d.play()
	Logger.info("{x} is playing audio: {y}".format({"x": parent_interactable.interactable_name,"y": audio_to_play}))
	super.on_interacted()
