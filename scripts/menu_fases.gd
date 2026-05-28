extends Control

@onready var fase1_btn = get_node("Fase1_btn")
@onready var fase2_btn = get_node("Fase2_btn")
@onready var fase3_btn = get_node("Fase3_btn")

@onready var fase1_stars = [get_node("Fase1_btn/star1"), get_node("Fase1_btn/star2"), get_node("Fase1_btn/star3")]
@onready var fase2_stars = [get_node("Fase2_btn/star1"), get_node("Fase2_btn/star2"), get_node("Fase2_btn/star3")]
@onready var fase3_stars = [get_node("Fase3_btn/star1"), get_node("Fase3_btn/star2"), get_node("Fase3_btn/star3")]

var save
var star_tex = load("res://assets/sprites/buttons_icons7.png")

func _ready() -> void:
	var scores = GlobalGD.scores
	if (scores[0] >= 0):
		fase2_btn.disabled = false
	else:
		fase2_btn.disabled = true
	if (scores[1] >= 0):
		fase3_btn.disabled = false
	else:
		fase3_btn.disabled = true
	
	for i in scores[0]:
		fase1_stars[i].texture = star_tex
	for i in scores[1]:
		fase2_stars[i].texture = star_tex
	for i in scores[2]:
		fase3_stars[i].texture = star_tex

func _on_voltar_btn_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_inicial.tscn")
