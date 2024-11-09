extends InteractComponent


@export var packed_scene_to_spawn : PackedScene



func on_interacted():
	super.on_interacted()
	if packed_scene_to_spawn == null:
		Logger.warn("No packedscene assigned")
		return
	var new_scene := packed_scene_to_spawn.instantiate() as Node2D
	parent_interactable.get_parent().add_child(new_scene)
	new_scene.global_position = parent_interactable.global_position
	parent_interactable.queue_free()
	Logger.info("{x} transformed into {y}".format({"x": parent_interactable.interactable_name,"y": new_scene.interactable_name}))
