extends Control

@export var flashing:= false:
	set(x):
		flashing =x
		modulate = Color.WHITE
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if flashing:
		modulate = Color.WHITE + Color.WHITE * sin(Time.get_ticks_msec()*InteractComponent.HIGHLIGHT_OSCILATE_SPEED /1000)*InteractComponent.HIGHLIGHT_OSCILATE_AMOUNT
		modulate.a = 1.0
