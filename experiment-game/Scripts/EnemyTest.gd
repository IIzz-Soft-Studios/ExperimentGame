extends CharacterBody2D

#on load
@onready var gun_point = $GunPoint
@onready var shoot_timer = $ShootTimer
@onready var burst_timer = $BurstTimer
@onready var player = get_tree().get_nodes_in_group("Player")[0]
@onready var vitals = $Vitals  # Make sure node is named this
@onready var vitals_ui: VitalsUI = get_node_or_null("VitalsUI")

#Export
@export var speed: float = 100 #Temporaliy downward momvment 
@export var circle_radius: float = 100.0
@export var circle_speed: float = .5  # radians per second


#bullet enemy attacking variables
var bullet_scene = preload("res://Scenes/bullet.tscn")
const BURST_COUNT = 5		# Number of bullets per burst
const BURST_DELAY = 0.4     # Time between each bullet
const COOLDOWN = 5.0        # Wait time between bursts
var bullets_fired = 0


func _ready():
	#Timer
	shoot_timer.wait_time = COOLDOWN
	burst_timer.wait_time = BURST_DELAY
	shoot_timer.start()

	if vitals_ui:
		vitals.vitals_changed.connect(vitals_ui.update_vitals)
		vitals_ui.update_vitals(vitals.oil, vitals.stamina, vitals.fuel)
		#print("Connected vitals_changed to UI!")


func _on_shoot_timer_timeout():
	bullets_fired = 0
	shoot_bullet()
	burst_timer.start()

func _on_burst_timer_timeout():
	bullets_fired += 1
	if bullets_fired < BURST_COUNT:
		shoot_bullet()
		burst_timer.start()
	else:
		shoot_timer.start()
		
#Bullet spawning and moving
func shoot_bullet():
	var bullet = bullet_scene.instantiate()
	#print("Bullet instance type:", bullet)

	if "source" in bullet:
		bullet.source = "enemy"
		#print("SUCCESS: bullet.source set to 'enemy'.")
	#else:
		#print("ERROR: 'source' property NOT found on bullet instance!")

	bullet.position = gun_point.global_position
	bullet.rotation = gun_point.global_rotation

	get_node("/root/Game").add_child(bullet)
	#print("Bullet added to scene at position:", bullet.position, "rotation:", bullet.rotation)
	
#Movment
enum State { APPROACH, CIRCLE, FOLLOW }
var state = State.APPROACH
var angle := 0.0  # for circular motion
var circle_center: Vector2  # position to circle around
const FOLLOW_DISTANCE = 700.0  # Distance to start circling

func _physics_process(delta):
	match state:
		State.APPROACH:
			velocity = Vector2(0, speed)
			move_and_slide()

			# Once enemy passes below player by a buffer, start following
			if global_position.y > player.global_position.y + 100:
				state = State.FOLLOW

		State.FOLLOW:
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
			move_and_slide()

			if global_position.distance_to(player.global_position) <= FOLLOW_DISTANCE:
				state = State.CIRCLE
				circle_center = player.global_position
				angle = (global_position - circle_center).angle()

		State.CIRCLE:
			circle_center = player.global_position  # continuously update for moving player
			angle += circle_speed * delta
			global_position = circle_center + Vector2(cos(angle), sin(angle)) * FOLLOW_DISTANCE
			# Rotate around the player
			look_at(player.global_position)

func apply_oil_damage(amount: float) -> void:
	if vitals:
		vitals.apply_oil_damage(amount)

# Vital Logic
func _on_enemy_died():
	queue_free()  # Replace with explosion/death VFX later
