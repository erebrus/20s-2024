class_name RonaldCrump
extends Node2D

@export var button: Interactable

var moveSpeed := 150.0
const distanceFromButtonForGameOver := 100.0
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var area_2d: Area2D = $Area2D
@onready var voice_player: AudioStreamPlayer2D = $VoicePlayer
var position_last_frame : Vector2

var pause_movement := false

@export_group("Voice Lines")
@export var made_in_china_line: AudioStream
@export var crudely_drawn_button_line: AudioStream

func _ready() -> void:
	navigation_agent_2d.target_position = button.global_position
	area_2d.area_entered.connect(_on_area_2d_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if pause_movement:
		return
	position_last_frame = global_position
	global_position = global_position.move_toward(navigation_agent_2d.get_next_path_position(),moveSpeed * delta)



func on_reached_button():


	if button.interactable_name == "Big Beautiful Chinese Button" and voice_player.stream != made_in_china_line:
		await change_voice_line(made_in_china_line)
		pause_movement = true
		await voice_player.finished
		Globals.do_win()
		return
	if button.interactable_name == "Crudely Drawn Button" and voice_player.stream != made_in_china_line:
		await change_voice_line(crudely_drawn_button_line)
		pause_movement = true
		await voice_player.finished
		Globals.do_win()
		return
	Globals.do_lose()

func _on_area_2d_area_entered(area: Area2D) -> void:
	var interacable_hit := area.get_parent()
	if interacable_hit is Interactable:
		if interacable_hit == button:
			on_reached_button()
			return



var audiostream_volume_tween: Tween

func change_voice_line(new_stream: AudioStream):
	if audiostream_volume_tween:
		audiostream_volume_tween.kill()
	audiostream_volume_tween = create_tween()
	audiostream_volume_tween.tween_property(voice_player,"volume_db",-60, .2)
	await audiostream_volume_tween.finished
	voice_player.volume_db = 0
	voice_player.stream = new_stream
	voice_player.play()
	return audiostream_volume_tween
