extends Node2D

@export var button: Node2D

var moveSpeed := 200.0
const distanceFromButtonForGameOver := 100.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = global_position.move_toward(button.global_position,moveSpeed * delta)

	if global_position.distance_to(button.global_position) <distanceFromButtonForGameOver:
		on_reached_button()


func on_reached_button():
	Globals.do_lose()
