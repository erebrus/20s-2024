extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var crump := get_tree().get_first_node_in_group("Crump") as RonaldCrump
	crump.button = get_parent() as Interactable
