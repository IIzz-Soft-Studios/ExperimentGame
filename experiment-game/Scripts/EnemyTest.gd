extends CharacterBody2D

@onready var gun_point = $GunPoint
@onready var shoot_timer = $ShootTimer
@onready var burst_timer = $BurstTimer

var bullet_scene = preload("res://Scenes/Bullet.tscn")

const BURST_COUNT = 5
const BURST_DELAY = 0.4     # Time between each bullet
const COOLDOWN = 5.0        # Wait time between bursts

var bullets_fired = 0

func _ready():
	shoot_timer.wait_time = COOLDOWN
	burst_timer.wait_time = BURST_DELAY
	shoot_timer.start()

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

func shoot_bullet():
	var bullet = bullet_scene.instantiate()
	bullet.position = gun_point.global_position
	bullet.rotation = gun_point.global_rotation
	bullet.source = "enemybullet"
	get_node("/root/Game").add_child(bullet)  # Update this path to match your game
	print("Bullet spawn:", bullet.position, "Gunpoint rotation:", bullet.rotation)
