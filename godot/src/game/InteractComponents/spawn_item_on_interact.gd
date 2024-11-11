extends InteractComponent

@export var number_of_times_this_can_be_interacted_with := 1
@export var packed_scenes_to_spawn : Array[PackedScene]
@export var random_jump_diameter := 200.0


func on_interacted():
	if number_of_times_this_can_be_interacted_with <= 0:
		return
	if packed_scenes_to_spawn.is_empty():
		Logger.warn("No packedscenes assigned")
		return

	for scene in packed_scenes_to_spawn:
		var new_scene := scene.instantiate() as Node2D
		parent_interactable.get_parent().add_child(new_scene)
		new_scene.global_position = parent_interactable.global_position

		if new_scene is Interactable:
			var point_to_jump_to := Vector2(randf_range(-1,1),randf_range(-1,1)) * random_jump_diameter + new_scene.position
			new_scene.tween_to_position(point_to_jump_to,.4).set_trans(Tween.TRANS_SINE)

		Logger.info("{x} spawned {y}".format({"x": parent_interactable.interactable_name,"y": new_scene.interactable_name}))
	number_of_times_this_can_be_interacted_with -= 1
	super.on_interacted()
