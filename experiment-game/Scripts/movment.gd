extends CharacterBody2D

const BASE_SPEED = 300.0
const SPEED_BOOST = 1.5

func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if direction.length() > 0:
		direction = direction.normalized()
	
	var current_speed = BASE_SPEED
	if Input.is_action_pressed("ui_accept"):  # Optional: Replace this with your own "boost" action
		current_speed *= SPEED_BOOST
	
	velocity = direction * current_speed
	move_and_slide()
