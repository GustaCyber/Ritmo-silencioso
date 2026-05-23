extends Node2D

# Onreadys
@onready var l_btn = get_node("CanvasLayer/Control/left_button")
@onready var r_btn = get_node("CanvasLayer/Control/right_button")
@onready var audio_player = get_node("AudioPlayer")
@onready var control = get_node("CanvasLayer/Control")
@onready var campo_tempo = get_node("CanvasLayer/Control/campo_tempo")
@onready var linha = get_node("CanvasLayer/Control/campo_tempo/line")

# Constantes


# Variaveis
var current_music: Dictionary
var is_generated = false
var element_y_pos
var elements = []

func _ready() -> void:
	# Iniciar fase
	element_y_pos = campo_tempo.get_global_rect().position.y
	if (GlobalGD.level == 0):
		current_music = GlobalGD.musica1
		var song = load(current_music.path)
		audio_player.set_stream(song)
		audio_player.play()

func get_keys():
	if Input.is_action_just_pressed("ui_left"):
		l_btn.animar(1)
		var t = audio_player.get_playback_position() + AudioServer.get_time_since_last_mix()
		player_precision(t)
	if (Input.is_action_just_released("ui_left")):
		l_btn.animar(0)
		
	if (Input.is_action_just_pressed("ui_right")):
		r_btn.animar(1)
		var t = audio_player.get_playback_position() + AudioServer.get_time_since_last_mix()
		player_precision(t)
	if (Input.is_action_just_released("ui_right")):
		r_btn.animar(0)
		

func get_next_bit_time() -> float:
	var current_song_time = audio_player.get_playback_position() + AudioServer.get_time_since_last_mix()
	var current_pos:int = current_song_time/GlobalGD.time_per_bit1
	var next_bit = GlobalGD.time_per_bit1 * (current_pos+1)
	return next_bit - current_song_time

func get_next_bit() -> float:
	var current_song_time = audio_player.get_playback_position() + AudioServer.get_time_since_last_mix()
	var current_pos:int = current_song_time/GlobalGD.time_per_bit1
	var next_bit = GlobalGD.time_per_bit1 * (current_pos+1)
	return next_bit

func array_pos() -> int:
	var current_song_time = audio_player.get_playback_position() + AudioServer.get_time_since_last_mix()
	var current_pos:int = current_song_time/GlobalGD.time_per_bit1
	return current_pos

func create_elements():
	var new_element = preload("res://scenes/element.tscn")
	var next_bit = get_next_bit_time()
	if (next_bit <= GlobalGD.time_per_bit1 + GlobalGD.time_per_bit_margin1
	&& next_bit >= GlobalGD.time_per_bit1 - GlobalGD.time_per_bit_margin1):
		if (!is_generated):
			is_generated = true
			var pos = next_bit * GlobalGD.element_speed
			elements.push_back(new_element.instantiate())
			if (GlobalGD.musica1.array[array_pos()]):
				elements[-1].is_red = true
			elements[-1].global_position.x = GlobalGD.default_element_pos - pos
			linha.add_child(elements[-1])
	else:
		is_generated = false

func calc_prec(t0) -> int:
	var t1 = get_next_bit()
	if (t0 - t1 > t1 - t1/100*GlobalGD.prec_margin_B || t0 - t1 < -t1 + t1/100*GlobalGD.prec_margin_B):
		return -1
	elif (t0 - t1 < t1 - t1/100*GlobalGD.prec_margin_B || t0 - t1 > -t1 + t1/100*GlobalGD.prec_margin_B):
		return 1
	elif (t0 - t1 < t1 - t1/100*GlobalGD.prec_margin_A || t0 - t1 > -t1 + t1/100*GlobalGD.prec_margin_A):
		return 0
	return -1

func player_precision(t):
	elements.pop_front().eliminate()
	var prec = calc_prec(t)
	var prec_out = preload("res://scenes/Precision_out.tscn")
	var prec_out_ins = prec_out.instantiate()
	prec_out_ins.prec = prec
	prec_out_ins.position.x = get_viewport().get_visible_rect().size.x * 0.5 - 16
	prec_out_ins.position.y = get_viewport().get_visible_rect().size.y * 0.5 + 16
	control.add_child(prec_out_ins)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_keys()
	create_elements()
