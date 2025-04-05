extends RigidBody2D

@export var speed: float = 500.0
@export var lifetime: float = 2.0
var life_timer: float = 0.0

# Set this when spawning to define who fired the bullet
var source: String = "enemybullet"

func _ready():
	# Bullet movement setup
	gravity_scale = 0
	sleeping = false
	contact_monitor = true
	max_contacts_reported = 1
	set_continuous_collision_detection_mode(RigidBody2D.CCD_MODE_CAST_RAY)

	# Ensure bullet goes in the direction it’s facing
	linear_velocity = Vector2.RIGHT.rotated(rotation) * speed

	# Optional: Configure your collision layers here if needed
	# collision_layer = 1
	# collision_mask = 2

	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta):
	life_timer += delta
	if life_timer > lifetime:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if source == "enemy" and body.is_in_group("Enemies"):
		return
	if source == "player" and body.is_in_group("Player"):
		return

	if body.has_method("take_damage"):
		body.take_damage(1)

	print("Bullet hit:", body.name)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

#func _draw():
	#draw_line(Vector2.ZERO, linear_velocity.normalized() * 20, Color.YELLOW, 2)
