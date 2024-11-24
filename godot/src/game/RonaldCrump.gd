class_name RonaldCrump
extends Interactable

@export var button: Interactable
@export var speed:float = 60
@export var path:PathFollow2D

@export_group("Voice Lines")
@export var normal_button_line: AudioStream
@export var made_in_china_line: AudioStream
@export var crudely_drawn_button_line: AudioStream
@export var missing_button_line: AudioStream

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var voice_player: AudioStreamPlayer2D = $VoicePlayer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var pause_movement := false
var _audiostream_volume_tween: Tween

var _moveSpeed := 20.0


func _ready() -> void:
	super._ready()
	Globals.crump = self
	navigation_agent_2d.target_position = button.global_position
	area_2d.area_entered.connect(_on_area_2d_area_entered)
	sprite.play("walk")

func _process(delta: float) -> void:
	super._process(delta)
	if pause_movement:
		return
	#global_position = global_position.move_toward(navigation_agent_2d.get_next_path_position(),_moveSpeed * delta)
	path.progress+=speed*delta
	if path.progress_ratio == 1:
		on_reached_button()

func _on_area_2d_area_entered(area: Area2D) -> void:
	super._on_area_2d_area_entered(area)
	var interacable_hit := area.get_parent()


func on_reached_button():
	button = get_tree().get_first_node_in_group("Button")
	Events.OnCrumpReachedButton.emit()
	pause_movement = true
	if voice_player.playing:
		await voice_player.finished
	if button.interactable_name == "Big Beautiful Chinese Button":
		trigger_win(made_in_china_line)
		return
	if button.interactable_name == "Crudely Drawn Button" :
		trigger_lose(crudely_drawn_button_line)
		return
	if button.interactable_name == "Missing Button" :
		trigger_lose(missing_button_line)
		return
	if button.interactable_name == "Big Beautiful Button" :
		trigger_lose(normal_button_line)
		return
	Globals.do_lose()


func trigger_win(voice_line: AudioStream):
	await change_voice_line(voice_line)
	await voice_player.finished
	Globals.do_win()


func trigger_lose(voice_line: AudioStream):
	await change_voice_line(voice_line)
	await voice_player.finished
	Globals.do_lose()


func change_voice_line(new_stream: AudioStream):
	if _audiostream_volume_tween:
		_audiostream_volume_tween.kill()
	_audiostream_volume_tween = create_tween()
	_audiostream_volume_tween.tween_property(voice_player,"volume_db",-60, .2)
	await _audiostream_volume_tween.finished
	voice_player.volume_db = 0
	voice_player.stream = new_stream
	voice_player.play()
	return _audiostream_volume_tween
