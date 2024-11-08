class_name Shadow
extends Sprite2D

var pickupTween: Tween
var parent: Interactable

const PICKUP_OFFSET := Vector2(-20,20)
const HOVER_OFFSET := Vector2(-10,10)
const TWEEN_DURATION := .1

func _ready() -> void:
	parent = get_parent()

	if parent is Interactable:
		await parent.ready
		parent.OnGrabbed.connect(picked_up)
		parent.OnDropped.connect(dropped)
		parent.control.mouse_entered.connect(hovered)
		parent.control.mouse_exited.connect(de_hovered)

func hovered():
	if parent.draggable:
		tween_to_position(HOVER_OFFSET)

func de_hovered():
	tween_to_position(Vector2.ZERO)

func picked_up():
	tween_to_position(PICKUP_OFFSET)

func dropped():
	tween_to_position(HOVER_OFFSET)

func tween_to_position(pos: Vector2):
	if pickupTween:
		pickupTween.kill()
	pickupTween = create_tween()
	pickupTween.tween_property(self,"position", pos,TWEEN_DURATION)
