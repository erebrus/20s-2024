extends Interactable


@export var tennis_ball: Interactable
@export var speed := 100.0
@export var start_chasing_ball_sound: AudioStream
@export var crump: Interactable
var following_crump := false

func _ready() -> void:
	super._ready()
	tennis_ball.OnDropped.connect(on_tennis_ball_drop)
	crump.OnInteractedWithItem.connect(on_ball_interact_with_crump)
	$AnimatedSprite2D.play("default")

func on_ball_interact_with_crump(interactable: Interactable):
	if interactable.interactable_name == "Tennis Ball":
		following_crump = true
func on_tennis_ball_drop():
	if tennis_ball.current_state == DragState.IN_INVENTORY:
		return
	Globals.sound_effects_manager.play_sfx(start_chasing_ball_sound)
	if following_crump:
		if position_tween and position_tween.is_running():
			position_tween.kill()
		return
	tween_to_position(tennis_ball.position, tennis_ball.global_position.distance_to(global_position)/ speed)

func _process(delta: float) -> void:
	super._process(delta)
	if following_crump:
		global_position = global_position.move_toward(Globals.crump.global_position + Vector2.DOWN, speed * delta)
