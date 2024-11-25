extends InteractComponent

@export var number_of_times_this_can_be_interacted_with := 1
@export var packed_scenes_to_spawn : Array[PackedScene]


func on_interacted():
	if number_of_times_this_can_be_interacted_with <= 0:
		return
	if packed_scenes_to_spawn.is_empty():
		Logger.warn("No packedscenes assigned")
		return
	for scene in packed_scenes_to_spawn:
		var new_scene := scene.instantiate() as Node2D
		parent_interactable.get_parent().add_child(new_scene)
		if new_scene is Interactable:
			Globals.inventory.add_item_to_inventory(new_scene)
		Logger.info("{x} spawned {y}".format({"x": parent_interactable.interactable_name,"y": new_scene.interactable_name}))
	number_of_times_this_can_be_interacted_with -= 1
	super.on_interacted()
