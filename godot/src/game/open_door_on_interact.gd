extends InteractComponent

@export var nav_link_to_toggle: NavigationLink2D
@export var is_door_open := false
@export var one_shot := true

func _ready() -> void:
	super._ready()
	_door_state_changed()

func on_interacted():
	super.on_interacted()
	is_door_open = !is_door_open
	_door_state_changed()
	if one_shot:
		parent_interactable.interactable = false

func _door_state_changed():
	nav_link_to_toggle.enabled = is_door_open
	if is_door_open:
		tween_to_rotation(PI/2.0)
	else:
		tween_to_rotation(0.0)

var rotation_tween: Tween

func tween_to_rotation(new_rotation: float, tween_duration: float = 0.3) -> Tween:
	if rotation_tween:
		rotation_tween.kill()
	rotation_tween = create_tween()
	rotation_tween.tween_property(parent_interactable,"rotation",new_rotation, tween_duration)
	return rotation_tween
