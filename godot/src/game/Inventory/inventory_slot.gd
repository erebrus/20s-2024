class_name InventorySlot
extends TweenableControl

@export var empty_slot_texture: Texture2D
@export var occupied_slot_texture: Texture2D

var _is_mouse_over := false
var interactable_on_button : Interactable

@onready var item_hover_sound: AudioStreamPlayer = %ItemHoverSound
@onready var item_drop_sound: AudioStreamPlayer = %ItemDropSound
@onready var panel: TextureRect = $Panel




func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _input(event: InputEvent) -> void:
	if is_instance_valid(interactable_on_button) and !interactable_on_button.is_position_tweening():
		if event is InputEventMouseButton:
			interactable_on_button.position = size/2


func assign_item(item: Interactable, tween_to_position_time : float = 0.0):
	panel.texture = occupied_slot_texture
	interactable_on_button = item
	item.inventory_slot_in = self
	interactable_on_button.reparent(self)
	interactable_on_button.current_state = Interactable.DragState.IN_INVENTORY
	if tween_to_position_time == 0.0:
		interactable_on_button.position = size/2
	else:
		interactable_on_button.global_position = get_global_mouse_position()
		interactable_on_button.tween_to_position(size/2,tween_to_position_time,Tween.EASE_OUT,Tween.TRANS_BOUNCE)
	item_hover_sound.play()
	item.control.mouse_entered.connect(highlight)
	item.control.mouse_exited.connect(dehighlight)
	if item.control.size.x > item.control.size.y:
		interactable_on_button.tween_to_scale(Vector2.ONE *( size.x/interactable_on_button.control.size.x))
	else:
		interactable_on_button.tween_to_scale(Vector2.ONE *( size.y/interactable_on_button.control.size.y))


func _on_mouse_entered() -> void:
	_is_mouse_over = true
	if Interactable.CURRENT_GRABBED and !interactable_on_button:
		interactable_on_button = Interactable.CURRENT_GRABBED
		assign_item(Interactable.CURRENT_GRABBED)
	highlight()


func highlight():
	tween_to_scale(Vector2(1.1,1.1))


func dehighlight():
	tween_to_scale(Vector2.ONE)
	if !interactable_on_button:
		panel.texture = empty_slot_texture


func _on_mouse_exited() -> void:
	_is_mouse_over = false
	dehighlight()
	if interactable_on_button and Interactable.CURRENT_GRABBED and Interactable.CURRENT_GRABBED == interactable_on_button:
		interactable_on_button._start_dragging()


func take_from_slot():
	interactable_on_button.inventory_slot_in = null
	interactable_on_button.control.mouse_entered.disconnect(highlight)
	interactable_on_button.control.mouse_exited.disconnect(dehighlight)
	interactable_on_button = null
	panel.texture = empty_slot_texture
	item_drop_sound.play()
	dehighlight()
