extends RigidBody2D

@export var speed = 500.0
@export var lifetime = 2.0
var life_timer = 0.0

func _ready():
	print("Bullet origin local pos:", position)
	print("Bullet global pos:", global_position)

	# Set velocity based on the bullet's rotation (facing direction)
	linear_velocity = Vector2.RIGHT.rotated(rotation - deg_to_rad(90)) * speed

func _physics_process(delta):
	life_timer += delta
	if life_timer > lifetime:
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
