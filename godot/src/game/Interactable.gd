class_name Interactable
extends Sprite2D

@export var draggable := false
@export var interactable := true

static var CurrentGrabbed: Interactable
var isMouseOver := false
const HIGHLIGHT_SCALE:= Vector2(1.1,1.1)
const PICKED_UP_SCALE:= Vector2(1.2,1.2)

signal OnInteracted
signal OnGrabbed
signal OnDropped

@onready var control: Control = $Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	control.mouse_entered.connect(_mouse_focus_entered)
	control.mouse_exited.connect(_mouse_exited)
	control.gui_input.connect(_on_control_gui_input)

func _on_control_gui_input(event: InputEvent) -> void:
	if isMouseOver and event is InputEventMouseButton and event.button_index == 1:
		if event.double_click or !draggable:
			if event.is_pressed() and interactable:
				interact()
		else:
			if event.is_pressed():
				_start_dragging()
			else:
				_stop_dragging()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if CurrentGrabbed and CurrentGrabbed == self:
			global_position += event.relative

func interact():
	OnInteracted.emit()
	await tween_to_scale(Vector2(.8,.8)).finished
	await tween_to_scale(Vector2(1.1,1.1)).finished
	tween_to_scale(Vector2.ONE)

func _mouse_focus_entered() -> void:
#TODO	we can add a controller when we start building a level and we need to seperate interactables into different parents
	get_parent().move_child(self, -1)
	isMouseOver = true
	tween_to_scale(HIGHLIGHT_SCALE)

func _mouse_exited() -> void:
	isMouseOver = false
	tween_to_scale(Vector2.ONE)

func _start_dragging():
	if CurrentGrabbed:
		CurrentGrabbed.dropped_by_mouse()
	tween_to_scale(PICKED_UP_SCALE)
	CurrentGrabbed = self
	OnGrabbed.emit()

func _stop_dragging():
	if CurrentGrabbed == self:
		CurrentGrabbed = null
	tween_to_scale(HIGHLIGHT_SCALE)
	OnDropped.emit()

var scale_tween: Tween

func tween_to_scale(new_scale: Vector2, tween_duration: float = 0.1) -> Tween:
	if scale_tween:
		scale_tween.kill()
	scale_tween = create_tween()
	scale_tween.tween_property(self,"scale",new_scale, tween_duration)
	return scale_tween
