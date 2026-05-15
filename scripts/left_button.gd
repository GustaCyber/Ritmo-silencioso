extends TextureButton

@export var trans_duration: float = 0.2
var gradiente: Gradient


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	focus_mode = FOCUS_NONE
	if texture_normal is GradientTexture2D:
		texture_normal = texture_normal.duplicate()
		gradiente = texture_normal.gradient
		gradiente.set_color(0, GlobalGD.BLUE)
		gradiente.set_color(1, GlobalGD.BLACK)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_down() -> void:
	GlobalGD.animar_gradiente(GlobalGD.BLACK, GlobalGD.BLUE, gradiente, trans_duration)

func _on_button_up() -> void:
	GlobalGD.animar_gradiente(GlobalGD.BLUE, GlobalGD.BLACK, gradiente, trans_duration)
