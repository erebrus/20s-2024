extends ColorRect

@export var frame_duration:float = 1
@onready var scene_1: TextureRect = $Scene1
@onready var scene_2: TextureRect = $Scene2
@onready var scene_3: TextureRect = $Scene3
@onready var sfx_1: AudioStreamPlayer = $sfx1
@onready var sfx_2: AudioStreamPlayer = $sfx2
@onready var sfx_3: AudioStreamPlayer = $sfx3

func _ready() -> void:
	Events.OnCrumpGunShot.connect(play)

func play():
	show()
	sfx_1.play()
	await get_tree().create_timer(frame_duration).timeout
	sfx_2.play()
	scene_2.show()
	await get_tree().create_timer(frame_duration).timeout
	sfx_3.play()
	scene_3.show()
	await get_tree().create_timer(frame_duration).timeout
	Globals.do_lose()
