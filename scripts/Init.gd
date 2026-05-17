extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var data = GlobalGD.capturar_estado_salvo()
	if (data != null):
		GlobalGD.level = data.level
		GlobalGD.scores = data.scores
	else:
		GlobalGD.novo_jogo()
