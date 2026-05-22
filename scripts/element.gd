extends CharacterBody2D

const speed = GlobalGD.element_speed

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	velocity.x = speed
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
