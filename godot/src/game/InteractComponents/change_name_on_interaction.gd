extends InteractComponent


@export var new_name : String



func on_interacted():
	if new_name.is_empty():
		Logger.warn("No new_name assigned")
		return
	Logger.info("renaming {x} to {y}".format({"x": parent_interactable.interactable_name,"y": new_name}))
	parent_interactable.interactable_name = new_name
	#parent_interactable.control.tooltip_text = new_name
	super.on_interacted()
