extends Node2D

@export var button: Node2D

var moveSpeed := 100.0
const distanceFromButtonForGameOver := 100.0
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var area_2d: Area2D = $Area2D

var position_last_frame : Vector2



func _ready() -> void:
	navigation_agent_2d.target_position = button.global_position
	area_2d.area_entered.connect(_on_area_2d_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position_last_frame = global_position
	global_position = global_position.move_toward(navigation_agent_2d.get_next_path_position(),moveSpeed * delta)
	if global_position.distance_to(button.global_position) <distanceFromButtonForGameOver:
		on_reached_button()


func on_reached_button():
	Globals.do_lose()


func _on_area_2d_area_entered(area: Area2D) -> void:
	var interacable_hit := area.get_parent()
	if interacable_hit is Interactable:
		interacable_hit.interactable = false
		interacable_hit.draggable = false
		if Interactable.CurrentGrabbed == interacable_hit:
			interacable_hit._stop_dragging()

		var my_movement_direction := (global_position - position_last_frame).normalized()
		var kick_direction = my_movement_direction.rotated(randf_range(-PI/4,PI/4))
		interacable_hit.tween_to_position(interacable_hit.position + (kick_direction * 800.0),.4).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
