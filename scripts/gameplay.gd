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
var elements = []
var future_element_pos
var default_element_pos
var end_element_pos
var screen_size
var speed
var will_time

func _ready() -> void:
	# Iniciar fase
	screen_size = get_viewport().size
	future_element_pos = screen_size.x * 0.5
	default_element_pos = screen_size.x * 0.3
	end_element_pos = screen_size.x * 0.7
	speed = (future_element_pos-default_element_pos)/GlobalGD.time_per_bit1
	will_time = (future_element_pos-default_element_pos)/speed
	
	print(default_element_pos)
	print(end_element_pos)
	if (GlobalGD.level == 0):
		current_music = GlobalGD.musica1
		var song = load(current_music.path)
		audio_player.set_stream(song)
		audio_player.play()

func get_keys():
	if Input.is_action_just_pressed("ui_left"):
		l_btn.animar(1)
		var t0 = get_next_bit_time()
		player_precision(t0, null)
	if (Input.is_action_just_released("ui_left")):
		l_btn.animar(0)
		
	if (Input.is_action_just_pressed("ui_right")):
		r_btn.animar(1)
		var t0 = get_next_bit_time()
		player_precision(t0, null)
	if (Input.is_action_just_released("ui_right")):
		r_btn.animar(0)
		

func get_next_bit_time() -> float:
	var current_song_time = audio_player.get_playback_position() + AudioServer.get_time_since_last_mix()
	var current_pos:int = current_song_time/GlobalGD.time_per_bit1
	var next_bit = GlobalGD.time_per_bit1 * (current_pos+1)
	return next_bit - current_song_time

func get_current_time() -> float:
	return audio_player.get_playback_position() + AudioServer.get_time_since_last_mix()

func get_next_bit() -> float:
	var current_pos = array_pos()
	var next_bit = GlobalGD.time_per_bit1 * (current_pos+1)
	return next_bit

func array_pos() -> int:
	var current_song_time = audio_player.get_playback_position() + AudioServer.get_time_since_last_mix()
	var current_pos:int = current_song_time/GlobalGD.time_per_bit1
	return current_pos

func create_elements():
	var new_element = preload("res://scenes/element.tscn")
	var next_bit_time = get_next_bit_time()
	
	if (next_bit_time < will_time + will_time/100 * GlobalGD.error_margin
	&& next_bit_time > will_time - will_time/100 * GlobalGD.error_margin):
		if (!is_generated):
			is_generated = true
			elements.push_back(new_element.instantiate())
			if (GlobalGD.musica1.array[array_pos()]):
				elements[-1].is_red = true
			elements[-1].position.x = 0
			elements[-1].speed = speed
			linha.add_child(elements[-1])
	else:
		is_generated = false

func end_elements():
	for i in elements:
		if (i.global_position.x >= end_element_pos):
			player_precision(-1, i)

func calc_prec(t) -> int:
	print(t)
	if (t > GlobalGD.prec_margin_B/100.0 || t < -GlobalGD.prec_margin_B/100.0):
		return -1
	elif (t < GlobalGD.prec_margin_B/100.0 || t > -GlobalGD.prec_margin_B/100.0):
		return 1
	elif (t < GlobalGD.prec_margin_A/100.0 || t > -GlobalGD.prec_margin_A/100.0):
		return 0
	return -1

func player_precision(t0, el):
	var prec
	if (t0 > -1):
		prec = calc_prec(t0)
	else:
		prec = -1
	if (el == null):
		el = elements.pop_front()
	else:
		elements.erase(el)
	if (el != null):
		el.eliminate()
	var prec_out = preload("res://scenes/Precision_out.tscn")
	var prec_out_ins = prec_out.instantiate()
	prec_out_ins.prec = prec
	prec_out_ins.position.x = screen_size.x * 0.5 - 16
	prec_out_ins.position.y = screen_size.y * 0.5 + 16
	control.add_child(prec_out_ins)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_keys()
	create_elements()
	end_elements()
