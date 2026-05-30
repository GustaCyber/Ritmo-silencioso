extends Control
@onready var anim = get_node("AnimationTree/AnimationPlayer")
@onready var exit_button = get_node("Exit_button")

func _ready() -> void:
	anim.play("bounce")

func _on_exit_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_inicial.tscn")
