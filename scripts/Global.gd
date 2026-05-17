extends Node

# Constantes estetica
const BLACK = Color(0, 0, 0, 1)
const RED = Color(1, 0, 0.33, 1)
const BLUE = Color(0.33, 0, 1, 1)

# Constantes gameplay

# Constantes save
const FILE_PATH = "user://saveData.json"
const SAVE_BASE: Dictionary = {
	"level": 0,
	"scores": [-1, -1, -1, -1]
}

# Variaveis
var level: int = 0
var scores = [-1, -1, -1, -1]

# Funcoes de estetica
func mudar_cor_ponto_0(cor: Color, gradiente: Gradient):
	gradiente.set_color(0, cor)
func mudar_cor_ponto_1(cor: Color, gradiente: Gradient):
	gradiente.set_color(1, cor)

func animar_gradiente(corA: Color, corB: Color, gradiente: Gradient, duration: float):
	if not gradiente: return
	var tween = create_tween().set_parallel(true)
	tween.tween_method(mudar_cor_ponto_0.bind(gradiente), gradiente.get_color(0), corA, duration)
	tween.tween_method(mudar_cor_ponto_1.bind(gradiente), gradiente.get_color(1), corB, duration)

# Funcoes de gameplay

# Funcoes de save
func novo_jogo():
	var jstr = JSON.stringify(SAVE_BASE)
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	file.store_string(jstr)
	file.close()

func salvar_estado_atual():
	# Cria dados
	var data: Dictionary = SAVE_BASE
	data.level = level
	data.scores = scores
	var jstr = JSON.stringify(data)
	# Escreve no arquivo
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	file.store_string(jstr)
	file.close()

func capturar_estado_salvo():
	if (FileAccess.file_exists(FILE_PATH)):
		var file = FileAccess.open(FILE_PATH, FileAccess.READ)
		var content = file.get_as_text()
		return JSON.parse_string(content)
	else:
		return null

# Funcoes padrao
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
