class_name SoundEffectsManager
extends Node

@export var sound_effect_prototype: PackedScene
@export var default_interact_sound: AudioStream

var low_pass_filter : AudioEffectLowPassFilter



func _ready() -> void:
	low_pass_filter = AudioServer.get_bus_effect(1,0) as AudioEffectLowPassFilter
	Events.OnGameReload.connect(kill_all_sounds)

func reset_sound_effects():
	AudioServer.set_bus_effect_enabled(1,0,false)


func play_default_interact_sound():
	play_sfx(default_interact_sound)

func play_sfx(audio_stream: AudioStream):
	var sound_effect_player := sound_effect_prototype.instantiate() as AudioStreamPlayer
	add_child(sound_effect_player)
	sound_effect_player.finished.connect(func(): sound_effect_player.queue_free())
	sound_effect_player.stream = audio_stream
	sound_effect_player.play()


func kill_all_sounds():
	for child in get_children():
		child.queue_free()

func trigger_nuclear_ending():
	low_pass_filter.cutoff_hz = 5000
	AudioServer.set_bus_effect_enabled(1,0,true)

	var tween := create_tween()
	tween.tween_property(low_pass_filter,"cutoff_hz",400,1)
