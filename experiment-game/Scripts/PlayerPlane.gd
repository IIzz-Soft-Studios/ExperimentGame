extends CharacterBody2D

@onready var camera: Camera2D = $Camera2D
@onready var vitals: Node = $Vitals
@onready var vitals_ui: VitalsUI = get_node_or_null("VitalsUI")

@export var speed: float = 300.0
@export var screen_margin: float = 20.0

var bullet_scene = preload("res://Scenes/bullet.tscn")

func _ready():
	var viewport_size = get_viewport_rect().size
	position = viewport_size / 2

	if vitals_ui:
		vitals.vitals_changed.connect(vitals_ui.update_vitals)
		vitals_ui.update_vitals(vitals.oil, vitals.stamina, vitals.fuel)

func _physics_process(delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if direction.length() > 0:
		direction = direction.normalized()

	var current_speed = speed
	if Input.is_action_pressed("ui_accept"):  # Boost key (Shift/Enter/etc.)
		current_speed *= 1.5

		# Boosting: drain stamina
		if vitals.has_method("drain_stamina"):
			vitals.drain_stamina(vitals.stamina_drain_from_boost * delta)
		vitals.is_boosting = true
	else:
		vitals.is_boosting = false

	self.velocity = direction * current_speed
	move_and_slide()

	if Input.is_action_just_pressed("shoot"):
		shoot_bullet()

func shoot_bullet():
	var b = bullet_scene.instantiate()
	var muzzle = $GunPoint
	var direction = muzzle.global_transform.x.normalized()

	b.global_position = muzzle.global_position
	b.rotation = direction.angle()

	if b.has_method("set_velocity_from_direction"):
		b.set_velocity_from_direction(direction)

	get_tree().current_scene.add_child(b)

func _process(_delta):
	if camera:
		var target_offset = (get_global_mouse_position() - global_position) * 0.1
		camera.offset = target_offset.clamp(Vector2(-100, -100), Vector2(100, 100))

func apply_oil_damage(amount: float) -> void:
	if vitals:
		vitals.apply_oil_damage(amount)
