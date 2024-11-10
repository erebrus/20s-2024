class_name TweenableNode2D
extends Node2D


var scale_tween: Tween
var position_tween: Tween
var rotation_tween: Tween

func tween_to_scale(new_scale: Vector2, tween_duration: float = 0.1) -> Tween:
	if scale_tween:
		scale_tween.kill()
	scale_tween = create_tween()
	scale_tween.tween_property(self,"scale",new_scale, tween_duration)
	return scale_tween


func tween_to_position(position_to_tween_to: Vector2, tween_duration: float = 1.0) -> Tween:
	if position_tween:
		position_tween.kill()
	position_tween = create_tween()
	position_tween.tween_property(self,"position",position_to_tween_to, tween_duration)
	return position_tween

func tween_to_rotation(rotation_to_tween_to: float, tween_duration: float = 1.0) -> Tween:
	if rotation_tween:
		rotation_tween.kill()
	rotation_tween = create_tween()
	rotation_tween.tween_property(self,"rotation",rotation_to_tween_to, tween_duration)
	return rotation_tween
