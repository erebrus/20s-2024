class_name Inventory
extends CanvasLayer

var inventory_slots :Array[InventorySlot]
@onready var h_box_container: VBoxContainer = $HBoxContainer

func _ready() -> void:
	Globals.inventory = self
	for child in h_box_container.get_children():
		if child is InventorySlot:
			inventory_slots.push_back(child)

func add_item_to_inventory(item: Node2D):
	var _free_slot: InventorySlot
	for slot in inventory_slots:
		if slot.interactable_on_button == null:
			_free_slot = slot
			break

	if _free_slot:
		_free_slot.assign_item(item,0.8)
