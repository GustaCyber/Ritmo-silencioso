extends Node2D

# Onreadys
@onready var l_btn = get_node("CanvasLayer/Control/left_button")
@onready var r_btn = get_node("CanvasLayer/Control/right_button")
@onready var audio_player = get_node("AudioPlayer")
@onready var control = get_node("CanvasLayer/Control")
@onready var campo_tempo = get_node("CanvasLayer/Control/campo_tempo")
@onready var linha = get_node("CanvasLayer/Control/campo_tempo/line")
@onready var timer = get_node("Timer")
@onready var label = get_node("CanvasLayer/Control/Label")
@onready var lifebar = get_node("CanvasLayer/Control/LifeBar")
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
var init = false
var time_per_bit
var acertos = 0
var meio_acertos = 0
var erros = 0
var vida = 100
var tempo_atual
var pos_atual
var dif
var total_beats

func _ready() -> void:
	# Iniciar fase
	screen_size = get_viewport().size
	future_element_pos = screen_size.x * 0.5 + 8
	default_element_pos = screen_size.x * 0.3
	end_element_pos = screen_size.x * 0.7
	if (GlobalGD.current_level == 0):
		current_music = GlobalGD.musica1
		time_per_bit = GlobalGD.time_per_bit1
		speed = 300
		will_time = (future_element_pos-default_element_pos)/speed
		dif = ceili(will_time/time_per_bit)
		tempo_atual = -3 -will_time
		total_beats = GlobalGD.total_beats1
	elif (GlobalGD.current_level == 1):
		current_music = GlobalGD.musica2
		time_per_bit = GlobalGD.time_per_bit2
		speed = 300
		will_time = (future_element_pos-default_element_pos)/speed
		dif = ceili(will_time/time_per_bit)
		tempo_atual = -3 -will_time
		total_beats = GlobalGD.total_beats2
	elif (GlobalGD.current_level == 2):
		current_music = GlobalGD.musica3
		time_per_bit = GlobalGD.time_per_bit3
		speed = 300
		will_time = (future_element_pos-default_element_pos)/speed
		dif = ceili(will_time/time_per_bit)
		tempo_atual = -3 -will_time
		total_beats = GlobalGD.total_beats3
func get_keys():
	if Input.is_action_just_pressed("ui_left"):
		l_btn.animar(1)
		get_buttons(0)
	if (Input.is_action_just_released("ui_left")):
		l_btn.animar(0)
		
	if (Input.is_action_just_pressed("ui_right")):
		r_btn.animar(1)
		get_buttons(1)
	if (Input.is_action_just_released("ui_right")):
		r_btn.animar(0)
		

func get_buttons(id):
	var t0 = tempo_atual
	player_precision(t0, id)

func errar():
	vida -= GlobalGD.desconto

func perder():
	if (vida <= 0):
		get_tree().change_scene_to_file("res://scenes/GameOver.tscn")

func vencer():
	var score = (acertos*2 + meio_acertos)/total_beats
	if (GlobalGD.current_level == 0):
		GlobalGD.scores[0] = score
	elif (GlobalGD.current_level == 1):
		GlobalGD.scores[1] = score
	elif (GlobalGD.current_level == 2):
		GlobalGD.scores[2] = score
	GlobalGD.salvar_estado_atual()
	get_tree().change_scene_to_file("res://scenes/menu_inicial.tscn")

func get_next_bit_time() -> float:
	var current_song_time = audio_player.get_playback_position() + AudioServer.get_time_since_last_mix()
	var next_bit = time_per_bit * (array_pos() + 1)
	return next_bit - current_song_time

func get_current_time() -> float:
	return audio_player.get_playback_position() + AudioServer.get_time_since_last_mix()

func get_next_bit() -> float:
	var current_pos = array_pos()
	var next_bit = time_per_bit * (current_pos+1)
	return next_bit

func get_next_bit2() -> float:
	var next_bit = time_per_bit * (array_pos() + dif)
	return next_bit

func array_pos() -> int:
	var current_song_time = audio_player.get_playback_position() + AudioServer.get_time_since_last_mix()
	var current_pos= int(current_song_time/time_per_bit)
	return current_pos

func create_elements():
	var new_element = preload("res://scenes/element.tscn")
	var next_bit_time = get_next_bit2() - tempo_atual
	if (next_bit_time < will_time + will_time/100 * GlobalGD.error_margin &&
	next_bit_time > will_time - will_time/100 * GlobalGD.error_margin && pos_atual >= 0):
		if (!is_generated):
			is_generated = true
			elements.push_back(new_element.instantiate())
			if (current_music.array[pos_atual]):
				elements[-1].is_red = true
			elements[-1].position.x = 0
			elements[-1].speed = speed
			elements[-1].time = get_next_bit2()
			linha.add_child(elements[-1])
			timer.start(GlobalGD.cooldown)

func vibrate():
	var next_bit_time = get_next_bit2() - tempo_atual
	if (abs(next_bit_time) < GlobalGD.error_margin):
		if (current_music.array[pos_atual] == 0):
			Input.vibrate_handheld(100, 0.5)
		else:
			Input.vibrate_handheld(100, 1)

func end_elements():
	for i in elements:
		if (i.global_position.x >= end_element_pos):
			player_precision(0, -1)
			elements.erase(i)

func calc_prec(t0, el) -> int:
	if (el != null):
		var t1 = el.time
		if (abs(t1-t0) < GlobalGD.prec_margin_A/100.0):
			return 0
		elif (abs(t1-t0) < GlobalGD.prec_margin_B/100.0):
			return 1
	return -1

func player_precision(t0, btn):
	var prec
	var el
	if (!elements.is_empty()):
		el = elements.pop_front()
	if (btn > -1):
		if ( (el.is_red && btn == 1) || (el.is_red == false && btn == 0) ):
			prec = calc_prec(t0, el)
		else:
			prec = -1
	else:
		prec = -1
	if (el != null):
		el.eliminate()
	var prec_out = preload("res://scenes/Precision_out.tscn")
	var prec_out_ins = prec_out.instantiate()
	prec_out_ins.prec = prec
	prec_out_ins.position.x = screen_size.x * 0.5 - 16
	prec_out_ins.position.y = screen_size.y * 0.5 + 16
	control.add_child(prec_out_ins)
	reg_prec(prec)

func reg_prec(prec):
	if (prec == 0):
		acertos+=1
	elif (prec == 1):
		meio_acertos+=1
	elif (prec == -1):
		erros+=1
		errar()

func _process(delta: float) -> void:
	label.text = str(int(-tempo_atual))
	lifebar.value = vida
	tempo_atual += delta
	pos_atual = int(tempo_atual/time_per_bit) + dif
	if (!init && tempo_atual >= 0):
		tempo_atual = 0
		label.visible = false
		var song = load(current_music.path)
		audio_player.set_stream(song)
		audio_player.play()
		init = true
	if (init):
		tempo_atual = get_current_time()
	create_elements()
	end_elements()
	get_keys()
	vibrate()
	perder()


func _on_timer_timeout() -> void:
	is_generated = false


func _on_audio_player_finished() -> void:
	vencer()
