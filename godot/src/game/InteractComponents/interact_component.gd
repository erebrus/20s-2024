class_name InteractComponent
extends Node2D

var parent_interactable: Interactable

@export var require_item_to_interact:= false
@export var possible_items_needed_for_interaction: Array[String]
@export var destroy_other_on_use := false
# TODO add sound/ vfx on successful interaction


func _ready() -> void:
	parent_interactable = get_parent()
	if parent_interactable is Interactable:
		if require_item_to_interact:
			parent_interactable.OnInteractedWithItem.connect(on_try_item_interacted)
		else:
			parent_interactable.OnInteracted.connect(on_interacted)

		parent_interactable.OnOverlappedInteractablesChanged.connect(check_if_overlap_is_required_item)
	else:
		Logger.warn("parent is not interactable")

func on_interacted():
	pass

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
