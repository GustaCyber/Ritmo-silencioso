extends TextureButton

@onready var gameplay = self.get_node("../../../../Gameplay")

@export var trans_duration: float = 0.2
var gradiente: Gradient

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	focus_mode = FOCUS_NONE
	if texture_normal is GradientTexture2D:
		texture_normal = texture_normal.duplicate()
		gradiente = texture_normal.gradient
		gradiente.set_color(0, GlobalGD.RED)
		gradiente.set_color(1, GlobalGD.BLACK)

func animar(id:int):
	if (id == 1):
		GlobalGD.animar_gradiente(GlobalGD.BLACK, GlobalGD.RED, gradiente, trans_duration)
	else:
		GlobalGD.animar_gradiente(GlobalGD.RED, GlobalGD.BLACK, gradiente, trans_duration)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_down() -> void:
	GlobalGD.animar_gradiente(GlobalGD.BLACK, GlobalGD.RED, gradiente, trans_duration)
	if (gameplay.init):
		gameplay.get_buttons(1)


func _on_button_up() -> void:
	GlobalGD.animar_gradiente(GlobalGD.RED, GlobalGD.BLACK, gradiente, trans_duration)
