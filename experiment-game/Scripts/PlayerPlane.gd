extends CharacterBody2D

@export var speed: float = 300.0
@export var screen_margin: float = 20.0

func _ready():
	# Get the viewport size
	var viewport_size = get_viewport_rect().size
	
	# Set initial position to center of screen
	position = viewport_size / 2

func _physics_process(delta):
	# Get input direction
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	# Normalize direction to prevent faster diagonal movement
	if direction.length() > 0:
		direction = direction.normalized()
	
	# Calculate movement
	velocity = direction * speed
	
	# Move the character
	move_and_slide()
	
	# Keep player within screen bounds
	var viewport_size = get_viewport_rect().size
	position.x = clamp(position.x, screen_margin, viewport_size.x - screen_margin)
	position.y = clamp(position.y, screen_margin, viewport_size.y - screen_margin) 