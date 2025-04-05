extends CharacterBody2D

@export var speed: float = 300.0
@export var screen_margin: float = 20.0

var bullet_scene = preload("res://Scenes/bullet.tscn")

func _ready():
	# Get the viewport size
	var viewport_size = get_viewport_rect().size
	
	# Set initial position to center of screen
	position = viewport_size / 2

func _physics_process(_delta):
	# Get input direction
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	#print("Velocity: ", self.velocity)

	# Normalize direction to prevent faster diagonal movement
	if direction.length() > 0:
		direction = direction.normalized()
	
	# Calculate speed with boost
	var current_speed = speed
	if Input.is_action_pressed("ui_accept"):  # Space bar for speed boost
		current_speed *= 1.5
	
	# Calculate movement
	self.velocity = direction * current_speed
	
	# Move the character
	move_and_slide()
	
	# Keep player within screen bounds
	var viewport_size = get_viewport_rect().size
	position.x = clamp(position.x, screen_margin, viewport_size.x - screen_margin)
	position.y = clamp(position.y, screen_margin, viewport_size.y - screen_margin)
	
	# Handle shooting
	if Input.is_action_just_pressed("shoot"):
		shoot_bullet()
		print("shooting")
		
func shoot_bullet():
	var b = bullet_scene.instantiate()

	var muzzle = $GunPoint
	var direction = muzzle.global_transform.x.normalized()

	b.global_position = muzzle.global_position
	b.rotation = direction.angle()
	
	# Set bullet velocity using its own method (recommended for RigidBody2D)
	if b.has_method("set_velocity_from_direction"):
		b.set_velocity_from_direction(direction)

	get_tree().current_scene.add_child(b)
	print("Bullet spawned at:", b.global_position, "Direction:", direction)
