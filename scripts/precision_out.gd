extends CharacterBody2D
# Onreadys
@onready var animate = get_node("animate")
@onready var timer = get_node("Timer")
# Constantes
const speed = 500
# Variaveis
var prec = 0

func _ready() -> void:
	if (prec == 0):
		animate.play("A")
	elif (prec == 1):
		animate.play("B")
	else:
		animate.play("C")
	timer.start(.5)


func _physics_process(delta: float) -> void:
	velocity.y -= speed * delta
	move_and_slide()


func _on_timer_timeout() -> void:
	self.queue_free()
