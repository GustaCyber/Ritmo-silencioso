extends CharacterBody2D

# Onreadys
@onready var anim = get_node("AnimatedSprite2D")
@onready var timer = get_node("Timer")
# Constantes

# Variaveis
var is_red = false
var speed = 100
var time
var weight = 1.0
var animation = false
var move = true

func _ready() -> void:
	if (is_red):
		anim.play("red")
	else:
		anim.play("blue")

func _physics_process(delta: float) -> void:
	# MOVE
	if (move):
		velocity.x = speed * delta * 60
	else:
		velocity.x = 0
	move_and_slide()
	# ANIMATE
	if (animation):
		weight = lerp(weight, 0.0, delta/4)
		modulate *= weight

func eliminate():
	move = false
	animation = true
	timer.start(0.5)


func _on_timer_timeout() -> void:
	self.queue_free()
