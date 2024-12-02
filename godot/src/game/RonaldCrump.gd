class_name RonaldCrump
extends Interactable

@export var button: Interactable
@export var speed:float = 60
@export var path:PathFollow2D
@export var camera_shaker: ShakerComponent2D
@export var lose_background : TweenableControl
@export var blast_sound: AudioStream
@export_group("Voice Lines")
@export var normal_button_line: AudioStream
@export var made_in_china_line: AudioStream
@export var crudely_drawn_button_line: AudioStream
@export var missing_button_line: AudioStream
@export var fake_on_real_button_line: AudioStream

@onready var voice_player: AudioStreamPlayer2D = $VoicePlayer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var pause_movement := false
var _audiostream_volume_tween: Tween
var has_reached_button := false
var _moveSpeed := 20.0


func _ready() -> void:
	super._ready()
	Globals.crump = self
	area_2d.area_entered.connect(_on_area_2d_area_entered)
	sprite.play("walk")
	sprite.frame_changed.connect(on_frame_changed)

func _process(delta: float) -> void:
	super._process(delta)
	if pause_movement:
		return
	if !has_reached_button:
		path.progress+=speed*delta
		if path.progress_ratio == 1:
			on_reached_button()
			sprite.animation = "push_button"
			has_reached_button = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	super._on_area_2d_area_entered(area)
	var interacable_hit := area.get_parent()

func on_frame_changed():
	if sprite.animation == "push_button" and sprite.frame == 5:
		button.interact()


func on_reached_button():
	button = get_tree().get_first_node_in_group("Button")
	Events.OnCrumpReachedButton.emit()
	pause_movement = true
	if button.interactable_name == "Big Beautiful Chinese Button":
		trigger_lose(made_in_china_line)
		return
	if button.interactable_name == "Crudely Drawn Button" :
		trigger_win(crudely_drawn_button_line)
		return
	if button.interactable_name == "Missing Button" :
		trigger_lose(missing_button_line)
		return
	if button.interactable_name == "Big Beautiful Button" :
		trigger_lose(normal_button_line)
		return
	if button.interactable_name == "Button with Fake Button on Top" :
		trigger_lose(fake_on_real_button_line)
		return
	Logger.error("missing button type")
	Globals.do_lose()


func trigger_win(voice_line: AudioStream):
	change_voice_line(voice_line)
	await voice_player.finished
	Globals.do_win()


func trigger_lose(voice_line: AudioStream):
	change_voice_line(voice_line)
	Globals.do_lose()
	await get_tree().create_timer(voice_player.stream.get_length()-3).timeout
	Globals.sound_effects_manager.trigger_nuclear_ending()
	camera_shaker.play_shake()
	await get_tree().create_timer(2).timeout
	Globals.sound_effects_manager.play_sfx(blast_sound)
	lose_background.tween_to_alpha(1,3)



func change_voice_line(new_stream: AudioStream):
	if _audiostream_volume_tween:
		_audiostream_volume_tween.kill()
	_audiostream_volume_tween = create_tween()
	_audiostream_volume_tween.tween_property(voice_player,"volume_db",-60, .1)
	await _audiostream_volume_tween.finished
	voice_player.volume_db = 0
	voice_player.stream = new_stream
	voice_player.play()
	return _audiostream_volume_tween
