extends Control

@onready var play_btn = get_node("Play_button")
@onready var exit_btn = get_node("Exit_button")
@onready var timer = get_node("Timer")
@onready var titulo = get_node("Titulo")

var title_tex1 = load("res://assets/sprites/titulo1.png")
var title_tex2 = load("res://assets/sprites/titulo2.png")
var current_tex = 0

func _ready() -> void:
	titulo.texture = title_tex1
	timer.start(2)

func _on_timer_timeout() -> void:
	if (current_tex == 0):
		titulo.texture = title_tex2
		current_tex = 1
	else:
		titulo.texture = title_tex1
		current_tex = 0
	timer.start(2)

func _on_play_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_fases.tscn")

func _on_exit_button_button_up() -> void:
	get_tree().quit()
