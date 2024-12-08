extends Interactable

const BUTTON_SCENE:PackedScene = preload("res://src/game/Interactables/big_beautiful_button.tscn")

func _ready():
	super._ready()
	Events.OnButtonRestored.connect(_OnButtonRestored)

func _OnButtonRestored():	
	var new_scene := load("res://src/game/Interactables/big_beautiful_button.tscn").instantiate() as Node2D
	self.get_parent().add_child(new_scene)
	new_scene.global_position = self.global_position
	if self.current_state == Interactable.DragState.IN_INVENTORY:
		Globals.inventory.add_item_to_inventory(new_scene)
	queue_free()
