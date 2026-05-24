extends CharacterBody2D

# Onreadys
@onready var anim = get_node("AnimatedSprite2D")

# Constantes

# Variaveis
var is_red = false
var speed = 100
var time

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
