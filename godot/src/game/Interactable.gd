class_name Interactable
extends TweenableNode2D

enum DragState{
	DROPPED,
	DRAGGING,
	IN_INVENTORY,
}

@export var interactable_name := "No name assigned"
@export var draggable := false
@export var interactable := true


static var CURRENT_GRABBED: Interactable
static var DRAGGING_PARENT: Node2D
static var DROPPED_PARENT: Node2D
var inventory_slot_in : InventorySlot
var isMouseOver := false
var current_state:= DragState.DROPPED:
	set(x):
		Logger.info("item changed state to: " + DragState.keys()[x])
		current_state = x

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var shadow: Shadow = %Shadow
@onready var area_2d: Area2D = $Area2D
var overlappingInteractables : Array[Interactable]


const HIGHLIGHT_SCALE:= Vector2(1.1,1.1)
const PICKED_UP_SCALE:= Vector2(1.2,1.2)
const CLICK_DELAY_TIME := 0.2
var _click_timer:float = 0.0

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

func _process(delta: float) -> void:
	_click_timer += delta
func _on_control_gui_input(event: InputEvent) -> void:
	if isMouseOver and event is InputEventMouseButton and event.button_index == 1:
		if draggable:
			if event.is_pressed():
				_click_timer = 0
				_start_dragging()
				get_viewport().set_input_as_handled()

		else:
			if event.is_pressed() and interactable:
				interact()
				get_viewport().set_input_as_handled()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if current_state == DragState.DRAGGING:
			global_position =  get_global_mouse_position()
	if current_state == DragState.DRAGGING and event is InputEventMouseButton and event.button_index == 1:
		if _click_timer < CLICK_DELAY_TIME:
			Globals.inventory.add_item_to_inventory(self)

	if event is InputEventMouseButton and event.button_index == 1 and CURRENT_GRABBED and CURRENT_GRABBED == self :
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
	if CURRENT_GRABBED != null:
		return

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
	if draggable:
		get_parent().move_child(self, -1)
	if current_state != DragState.IN_INVENTORY:
		tween_to_scale(HIGHLIGHT_SCALE)

func de_highlight():
	if current_state != DragState.IN_INVENTORY:
		tween_to_scale(Vector2.ONE)
func _start_dragging():

	if CURRENT_GRABBED and is_instance_valid(CURRENT_GRABBED):
		CURRENT_GRABBED._stop_dragging()

	if current_state == DragState.IN_INVENTORY:
		inventory_slot_in.take_from_slot()
	current_state = DragState.DRAGGING
	control.mouse_filter =Control.MOUSE_FILTER_IGNORE
	reparent(DRAGGING_PARENT)
	global_position = get_global_mouse_position()
	tween_to_scale(PICKED_UP_SCALE)
	CURRENT_GRABBED = self
	OnGrabbed.emit()


func _stop_dragging():

	if CURRENT_GRABBED == self:
		CURRENT_GRABBED = null

	if area_2d:
		for overlapping_interactable in overlappingInteractables:
			overlapping_interactable.try_interact_with_item(self)

	if current_state != DragState.IN_INVENTORY:
		current_state = DragState.DROPPED
		reparent(DROPPED_PARENT)
		tween_to_scale(HIGHLIGHT_SCALE)
	control.mouse_filter =Control.MOUSE_FILTER_STOP

	OnDropped.emit()




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
