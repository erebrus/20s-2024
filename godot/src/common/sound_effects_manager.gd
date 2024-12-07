class_name SoundEffectsManager
extends Node

@export var sound_effect_prototype: PackedScene
@export var default_interact_sound: AudioStream

var low_pass_filter : AudioEffectLowPassFilter
var volumeTween: Tween


func _ready() -> void:
	low_pass_filter = AudioServer.get_bus_effect(1,0) as AudioEffectLowPassFilter
	Events.OnGameReload.connect(kill_all_sounds)

func reset_sound_effects():
	if volumeTween and volumeTween.is_running():
		volumeTween.kill()
	low_pass_filter.cutoff_hz = 5000
	SetVolumeForSFX(0)


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
	volumeTween = create_tween().set_parallel(true)
	volumeTween.tween_property(low_pass_filter,"cutoff_hz",400,9)
	volumeTween.tween_method(SetVolumeForSFX,0,-20,9)


func trigger_good_ending():
	volumeTween = create_tween().set_parallel(true)
	await get_tree().create_timer(5).timeout
	volumeTween.tween_method(SetVolumeForSFX,0,-20,9)


func SetVolumeForSFX(vol: float):
	var sfx_index = AudioServer.get_bus_index("Sound")
	AudioServer.set_bus_volume_db(sfx_index, vol)
