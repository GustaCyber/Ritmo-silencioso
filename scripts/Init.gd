extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var data = GlobalGD.capturar_estado_salvo(GlobalGD.FILE_PATH)
	if (data != null):
		GlobalGD.level = data.level
		GlobalGD.scores = data.scores
	else:
		GlobalGD.novo_jogo()
		GlobalGD.level = GlobalGD.SAVE_BASE.level
		GlobalGD.scores = GlobalGD.SAVE_BASE.scores
