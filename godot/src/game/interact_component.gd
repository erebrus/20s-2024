class_name InteractComponent
extends Node2D

var parent_interactable: Interactable



func _ready() -> void:
	parent_interactable = get_parent()
	if parent_interactable is Interactable:
		parent_interactable.OnInteracted.connect(on_interacted)
	else:
		Logger.warn("parent is not interactable")

func on_interacted():
	return
