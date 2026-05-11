extends Node2D



func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass

func getkeys() -> int:
	if Input.is_action_just_pressed("ui_left"):
		return -1
	return 1
