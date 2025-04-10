extends RigidBody2D

@export var speed: float = 500.0
@export var lifetime: float = 2.0
@export var damage: float = 5.0
@export var oil_damage: float = 3.0
@export var source: String = "player" # or "enemy" depending on who fired it

var life_timer: float = 0.0

 #Set this when spawning to define who fired the bullet
#var source = "enemy"

# Bullet movement setup
func _ready():
	print("Bullet node ready. Source =", source, "Rotation =", rotation, "Velocity =", linear_velocity)
	gravity_scale = 0
	sleeping = false
	contact_monitor = true
	max_contacts_reported = 1
	set_continuous_collision_detection_mode(RigidBody2D.CCD_MODE_CAST_RAY)
	# Ensure bullet goes in the direction it’s facing
	linear_velocity = Vector2.UP.rotated(rotation) * speed
	# Optional: Configure your collision layers here if needed
	# collision_layer = 1
	# collision_mask = 2
	connect("body_entered", Callable(self, "_on_body_entered"))

#bullet lifetime function
func _physics_process(delta):
	life_timer += delta
	if life_timer > lifetime:
		queue_free()
		
#Bullet detections
func _on_body_entered(body: Node) -> void:
	print("Bullet collided with body:", body.name, "Body groups:", body.get_groups())

	if source == "enemy" and body.is_in_group("Enemies"):
		print("Ignored collision with enemy (bullet fired by enemy).")
		return
	if source == "player" and body.is_in_group("Player"):
		print("Ignored collision with player (bullet fired by player).")
		return

	if body.has_method("apply_oil_damage"):
		print("Calling apply_oil_damage on", body.name)
		body.apply_oil_damage(oil_damage)
	else:
		print("Body has no apply_oil_damage method:", body.name)

	queue_free()


#despawn bullets
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

#func _draw():
	#draw_line(Vector2.ZERO, linear_velocity.normalized() * 20, Color.YELLOW, 2)
