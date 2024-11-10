class_name Interactable
extends TweenableNode2D

@export var interactable_name := "No name assigned"
@export var draggable := false
@export var interactable := true

static var CurrentGrabbed: Interactable
var isMouseOver := false
@onready var shadow: Shadow = %Shadow
@onready var area_2d: Area2D = $Area2D
var overlappingInteractables : Array[Interactable]


const HIGHLIGHT_SCALE:= Vector2(1.1,1.1)
const PICKED_UP_SCALE:= Vector2(1.2,1.2)

signal OnInteracted
signal OnInteractedWithItem(Interactable)
signal OnGrabbed
signal OnDropped
signal OnOverlappedInteractablesChanged


@onready var control: Control = $Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	control.tooltip_text = interactable_name
	control.mouse_entered.connect(_mouse_entered)
	control.mouse_exited.connect(_mouse_exited)
	control.gui_input.connect(_on_control_gui_input)

	if area_2d:
		area_2d.area_entered.connect(_on_area_2d_area_entered)
		area_2d.area_exited.connect(_on_area_2d_area_exited)
	if shadow:
		shadow.initialise(self)


func _on_control_gui_input(event: InputEvent) -> void:
	if isMouseOver and event is InputEventMouseButton and event.button_index == 1:
		if event.double_click or !draggable:
			if event.is_pressed() and interactable:
				interact()
		else:
			if event.is_pressed():
				_start_dragging()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if CurrentGrabbed and CurrentGrabbed == self:
			global_position += event.relative / get_viewport().get_camera_2d().zoom

	if event is InputEventMouseButton and event.button_index == 1 and CurrentGrabbed and CurrentGrabbed == self :
		_stop_dragging()

func interact():
	OnInteracted.emit()
	await tween_to_scale(Vector2(.8,.8)).finished
	await tween_to_scale(Vector2(1.1,1.1)).finished
	tween_to_scale(Vector2.ONE)

func try_interact_with_item(item_that_is_interacting_with_me: Interactable):
	OnInteractedWithItem.emit(item_that_is_interacting_with_me)
	await tween_to_scale(Vector2(.8,.8)).finished
	await tween_to_scale(Vector2(1.1,1.1)).finished
	tween_to_scale(Vector2.ONE)

func _mouse_entered() -> void:
#TODO	we can add a controller when we start building a level and we need to seperate interactables into different parents
	get_parent().move_child(self, -1)
	isMouseOver = true
	if interactable:
		highlight()
		if draggable:
			tween_to_rotation(PI/20, .1)

func _mouse_exited() -> void:
	isMouseOver = false
	de_highlight()
	if draggable:
		tween_to_rotation(0, .1)

func highlight():
	tween_to_scale(HIGHLIGHT_SCALE)

func de_highlight():
	tween_to_scale(Vector2.ONE)
func _start_dragging():
	if CurrentGrabbed:
		CurrentGrabbed._stop_dragging()
	tween_to_scale(PICKED_UP_SCALE)
	CurrentGrabbed = self
	OnGrabbed.emit()

func _stop_dragging():
	if CurrentGrabbed == self:
		CurrentGrabbed = null
	tween_to_scale(HIGHLIGHT_SCALE)
	OnDropped.emit()

	if area_2d:
		for overlapping_interactable in overlappingInteractables:
			overlapping_interactable.try_interact_with_item(self)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Interactable:
		overlappingInteractables.push_back(area.get_parent())
		OnOverlappedInteractablesChanged.emit()


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent() is Interactable:
		overlappingInteractables.erase(area.get_parent())
		OnOverlappedInteractablesChanged.emit()

func has_overlapping_interactable(interactable_name: String)->bool:
	for interactable in overlappingInteractables:
		if interactable.interactable_name == interactable_name:
			return true
	return false

#TODO add a destroy animation/effect and sound
func destroy():
	queue_free()
