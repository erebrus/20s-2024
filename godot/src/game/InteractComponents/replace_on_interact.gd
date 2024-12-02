extends InteractComponent


@export var packed_scene_to_replace_with : PackedScene



func on_interacted():
	if packed_scene_to_replace_with == null:
		Logger.warn("No packedscene assigned")
	else:
		var new_scene := packed_scene_to_replace_with.instantiate() as Node2D
		parent_interactable.get_parent().add_child(new_scene)
		new_scene.global_position = parent_interactable.global_position
		Logger.info("{x} transformed into {y}".format({"x": parent_interactable.interactable_name,"y": new_scene.interactable_name}))
		if parent_interactable.current_state == Interactable.DragState.IN_INVENTORY:
			Globals.inventory.add_item_to_inventory(new_scene)
	parent_interactable.queue_free()
	super.on_interacted()
