extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.OnHoverItem.connect(on_hover)
	Events.OnStopHoverItem.connect(on_hover_stop)


func on_hover(interactable: Interactable):
	text = interactable.interactable_name

func on_hover_stop(interactable: Interactable):
	if interactable.interactable_name == text:
		text = ""
