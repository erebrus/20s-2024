class_name InteractComponent
extends Node2D


const HIGHLIGHT_OSCILATE_SPEED: float = 8.0
const HIGHLIGHT_OSCILATE_AMOUNT: float = .5

@export var require_item_to_interact:= false
@export var possible_items_needed_for_interaction: Array[String]
@export var destroy_other_on_use := false
@export var make_parent_not_interactable_after_interaction := false
@export var successful_interact_sound: AudioStream
@export var muliply_trump_walk_speed := 1.0
var parent_interactable: Interactable

var _player_is_dragging_a_matching_item := false

signal OnInteracted




func _ready() -> void:
	parent_interactable = get_parent()
	Events.OnPickupItem.connect(on_any_item_picked_up)
	Events.OnDropItem.connect(on_any_item_dropped)
	if parent_interactable is Interactable:
		if require_item_to_interact:
			parent_interactable.OnInteractedWithItem.connect(on_try_item_interacted)
		else:
			parent_interactable.OnInteracted.connect(on_interacted)
		parent_interactable.OnOverlappedInteractablesChanged.connect(check_if_overlap_is_required_item)
	else:
		Logger.warn("parent is not interactable")


func _process(delta: float) -> void:
	if _player_is_dragging_a_matching_item:
		parent_interactable.modulate = Color.WHITE + Color.WHITE * sin(Time.get_ticks_msec()*HIGHLIGHT_OSCILATE_SPEED /1000)*HIGHLIGHT_OSCILATE_AMOUNT
		parent_interactable.modulate.a = 1.0


func on_interacted():
	if successful_interact_sound:
		Globals.sound_effects_manager.play_sfx(successful_interact_sound)
	if make_parent_not_interactable_after_interaction:
		parent_interactable.interactable = false
	Globals.crump.speed *= muliply_trump_walk_speed
	OnInteracted.emit()


func on_try_item_interacted(item_interacting_with_me: Interactable):
	if possible_items_needed_for_interaction.has(item_interacting_with_me.interactable_name):
		on_interacted()
		if destroy_other_on_use:
			item_interacting_with_me.destroy()

func check_if_overlap_is_required_item():
	for interactable in parent_interactable.overlappingInteractables:
		if possible_items_needed_for_interaction.has(interactable.interactable_name):
			parent_interactable.highlight()
			return
	parent_interactable.de_highlight()


func on_any_item_picked_up(name_of_item: String):
	if possible_items_needed_for_interaction.has(name_of_item):
		_player_is_dragging_a_matching_item = true


func on_any_item_dropped():
	_player_is_dragging_a_matching_item = false
	parent_interactable.modulate = Color.WHITE
