extends CharacterBody2D

# Onreadys
@onready var anim = get_node("AnimatedSprite2D")

# Constantes
const speed = GlobalGD.element_speed

# Variaveis
var is_red = false

func _ready() -> void:
	if (is_red):
		anim.play("red")
	else:
		anim.play("blue")
	
func _physics_process(delta: float) -> void:
	velocity.x = speed * delta * 60
	move_and_slide()

func eliminate():
	self.queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
