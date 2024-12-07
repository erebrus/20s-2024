class_name Shadow
extends Node2D

var pickupTween: Tween
var parent_interactable: Interactable

const PICKUP_OFFSET := Vector2(-20,20)
const HOVER_OFFSET := Vector2(-10,10)
const TWEEN_DURATION := .1

var starting_position : Vector2

func initialise(interactable: Interactable):
	parent_interactable = interactable
	parent_interactable.OnGrabbed.connect(picked_up)
	parent_interactable.OnDropped.connect(dropped)
	parent_interactable.control.mouse_entered.connect(hovered)
	parent_interactable.control.mouse_exited.connect(de_hovered)
	starting_position = position

func hovered():
	if parent_interactable.draggable:
		tween_to_position(HOVER_OFFSET)

func de_hovered():
	tween_to_position(starting_position)

func picked_up():
	tween_to_position(PICKUP_OFFSET)

func dropped():
	tween_to_position(HOVER_OFFSET)

func tween_to_position(pos: Vector2):
	if pickupTween:
		pickupTween.kill()
	pickupTween = create_tween()
	pickupTween.tween_property(self,"position", pos,TWEEN_DURATION)
