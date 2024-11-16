extends InteractComponent


@export var new_sprite : Texture2D



func on_interacted():
	if !new_sprite:
		Logger.warn("No new_name assigned")
		return
	Logger.info("changing sprite on {x} to {y}".format({"x": parent_interactable.interactable_name,"y": new_sprite.resource_name}))
	parent_interactable.sprite_2d.texture = new_sprite
	super.on_interacted()
