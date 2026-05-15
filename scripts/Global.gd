extends Node

const BLACK = Color(0, 0, 0, 1)
const RED = Color(1, 0, 0.33, 1)
const BLUE = Color(0.33, 0, 1, 1)


func mudar_cor_ponto_0(cor: Color, gradiente: Gradient):
	gradiente.set_color(0, cor)
func mudar_cor_ponto_1(cor: Color, gradiente: Gradient):
	gradiente.set_color(1, cor)

func animar_gradiente(corA: Color, corB: Color, gradiente: Gradient, duration: float):
	if not gradiente: return
	var tween = create_tween().set_parallel(true)
	tween.tween_method(mudar_cor_ponto_0.bind(gradiente), gradiente.get_color(0), corA, duration)
	tween.tween_method(mudar_cor_ponto_1.bind(gradiente), gradiente.get_color(1), corB, duration)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
