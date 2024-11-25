extends Node

const GAME_SCENE_PATH = "res://src/main.tscn"

@onready var sound_effects: AudioStreamPlayer = %SoundEffects
@onready var sound_effects_manager: SoundEffectsManager = $SoundEffectsManager


@onready var win_display: Control = %WinDisplay
@onready var lose_display: Control = %LoseDisplay
@onready var time_display: TimeDisplay = %TimeDisplay
@onready var dark_background: TweenableControl = $OverlayCanvas/DarkBackground






var master_volume:float = 100
var music_volume:float = 100
var sfx_volume:float = 100

const GameDataPath = "user://conf.cfg"
var config:ConfigFile

var debug_build := false
var in_game:=false

var crump: RonaldCrump
var inventory: Inventory

var music_on:=true:
	set(v):
		music_on=v
		Logger.info("music %s" % [music_on])
		var sfx_index= AudioServer.get_bus_index("Music")
		AudioServer.set_bus_volume_db(sfx_index, music_manager.music_bus_volume if music_on else -60)


var sound_on:=true:
	set(v):
		sound_on = v
		Logger.info("sound %s" % [sound_on])
		var sfx_index= AudioServer.get_bus_index("Sound")
		AudioServer.set_bus_volume_db(sfx_index, 0 if sound_on else -60)


@onready var music_manager: MusicManager = $MusicManager


func _ready():
	_init_logger()
	Logger.info("Starting menu music")
	music_manager.fade_in_menu_music()

	#start_game() #uncomment when we have start screen

func start_game():
	in_game=true
	win_display.visible = false
	lose_display.visible = false
	time_display.visible = true
	dark_background.modulate.a = 1
	time_display.currentTime = 0
	music_manager.fade_menu_music()
	sound_effects_manager.reset_sound_effects()
	await get_tree().create_timer(1).timeout
	music_manager.reset_synchronized_stream()

	get_tree().change_scene_to_file(GAME_SCENE_PATH)
	music_manager.fade_in_game_music()

func restart_game():
	get_tree().reload_current_scene()
	sound_effects_manager.reset_sound_effects()
	dark_background.tween_to_alpha(0,.5)
	win_display.visible = false
	lose_display.visible = false
	time_display.visible = true
	time_display.currentTime = 0



func _init_logger():
	Logger.set_logger_level(Logger.LOG_LEVEL_INFO)
	Logger.set_logger_format(Logger.LOG_FORMAT_MORE)
	var console_appender:Appender = Logger.add_appender(ConsoleAppender.new())
	console_appender.logger_format=Logger.LOG_FORMAT_FULL
	console_appender.logger_level = Logger.LOG_LEVEL_INFO
	var file_appender:Appender = Logger.add_appender(FileAppender.new("res://debug.log"))
	file_appender.logger_format=Logger.LOG_FORMAT_FULL
	file_appender.logger_level = Logger.LOG_LEVEL_DEBUG
	Logger.info("Logger initialized.")


func do_lose():
	lose_display.visible = true
	dark_background.tween_to_alpha(1,.5)


func do_win():
	Events.OnWinGame.emit()
	win_display.visible = true
	dark_background.tween_to_alpha(1,.5)
