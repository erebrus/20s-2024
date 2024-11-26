extends CanvasLayer

const PASSWORD := "1234"
const INDICATOR_SECONDS_PER_FLASH : float= .4
@export var safe_interactable: Interactable
@export var open_safe_sprite: Texture2D
@export var packed_scenes_to_spawn : Array[PackedScene]

@onready var readout_screen_text: Label = %ReadoutScreenText
@onready var background: TweenableControl = $Background
@onready var safe_image: TweenableControl = $Safe
@onready var button_press_sound: AudioStreamPlayer = $ButtonPressSound
@onready var open_safe_sound: AudioStreamPlayer = $OpenSafeSound


var _safe_starting_position : Vector2
var _current_entered_number : String = ""


func _ready() -> void:
	update_display()
	_safe_starting_position = safe_image.position
	show_input_flash()
	Events.OnCrumpReachedButton.connect(close_overlay)


func open_overlay():
	background.tween_to_alpha(.7,.1)
	safe_image.tween_to_scale(Vector2.ONE * .7,.3)
	safe_image.tween_to_position(background.size/2 - safe_image.size/2,.3)


func close_overlay():
	background.tween_to_alpha(0,.1)
	safe_image.tween_to_scale(Vector2.ZERO,.3)
	safe_image.tween_to_position(_safe_starting_position,.3)


func _on_number_pressed(number: int) -> void:
	button_press_sound.play()
	if _current_entered_number.length() > 3:
		update_display()
	else:
		_current_entered_number += str(number)
		update_display()


func show_input_flash():
	while(self):
		if _current_entered_number.length() <4:
			readout_screen_text.text += "_"
		await get_tree().create_timer(INDICATOR_SECONDS_PER_FLASH).timeout
		update_display()
		await get_tree().create_timer(INDICATOR_SECONDS_PER_FLASH).timeout

func update_display():
	readout_screen_text.text = _current_entered_number


func _on_clear_pressed() -> void:
	button_press_sound.play()
	_current_entered_number = ""
	update_display()


func _on_enter_pressed() -> void:
	button_press_sound.play()
	if _current_entered_number == PASSWORD:
		open_safe()
	else:
		_on_clear_pressed()
#		TODO PLAY SOUNDs


func open_safe():
	close_overlay()
	open_safe_sound.play()
	safe_interactable.interactable_name = "Open Safe"
	#safe_interactable.control.tooltip_text = "Open Safe"
	safe_interactable.sprite_2d.texture = open_safe_sprite
	safe_interactable.shadow.texture = open_safe_sprite
	safe_interactable.interactable = false
	await safe_image.scale_tween.finished
	for scene in packed_scenes_to_spawn:
		var new_scene := scene.instantiate() as Node2D
		safe_interactable.get_parent().add_child(new_scene)
		if new_scene is Interactable:
			Globals.inventory.add_item_to_inventory(new_scene)
		Logger.info("{x} spawned {y}".format({"x": safe_interactable.interactable_name,"y": new_scene.interactable_name}))
	visible = false
