class_name RonaldCrump
extends Interactable

@export var button: Interactable

var _moveSpeed := 150.0
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var voice_player: AudioStreamPlayer2D = $VoicePlayer
var pause_movement := false

@export_group("Voice Lines")
@export var made_in_china_line: AudioStream
@export var crudely_drawn_button_line: AudioStream
@export var missing_button_line: AudioStream

func _ready() -> void:
	super._ready()
	Globals.crump = self
	navigation_agent_2d.target_position = button.global_position
	area_2d.area_entered.connect(_on_area_2d_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if pause_movement:
		return
	global_position = global_position.move_toward(navigation_agent_2d.get_next_path_position(),_moveSpeed * delta)


func _on_area_2d_area_entered(area: Area2D) -> void:
	var interacable_hit := area.get_parent()
	if interacable_hit is Interactable:
		if interacable_hit == button:
			on_reached_button()
			return


func on_reached_button():
	if button.interactable_name == "Big Beautiful Chinese Button":
		trigger_win(made_in_china_line)
		return
	if button.interactable_name == "Crudely Drawn Button" :
		trigger_lose(crudely_drawn_button_line)
		return
	if button.interactable_name == "Missing Button" :
		trigger_lose(missing_button_line)
		return
	Globals.do_lose()


func trigger_win(voice_line: AudioStream):
	await change_voice_line(voice_line)
	pause_movement = true
	await voice_player.finished
	Globals.do_win()


func trigger_lose(voice_line: AudioStream):
	await change_voice_line(voice_line)
	pause_movement = true
	await voice_player.finished
	Globals.do_lose()


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
