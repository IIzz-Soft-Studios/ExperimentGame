extends Node

signal vitals_changed(oil: float, stamina: float, fuel: float)

@export var max_oil := 100.0
@export var max_stamina := 100.0
@export var max_fuel := 100.0
@export var fuel_drain_duration := 30 #600.0  # seconds to deplete from full
@export var stamina_regen_delay := 5.0  # seconds
@export var stamina_regen_rate := 10.0   # per second (adjust as needed)
@export var stamina_drain_from_boost := 20.0  # per second
@export var stamina_drain_from_hit := 10.0    # per oil hit

var oil := max_oil
var stamina := max_stamina
var fuel := max_fuel
var fuel_drain_rate := 0.0
var stamina_regen_timer := 0.0
var is_boosting := false

func _ready():
	fuel_drain_rate = max_fuel / fuel_drain_duration
	emit_signal("vitals_changed", oil, stamina, fuel)

func _process(delta: float) -> void:
	# Fuel drain
	if fuel > 0.0:
		fuel = clamp(fuel - fuel_drain_rate * delta, 0, max_fuel)

	# Stamina regen (only if not boosting or hit recently)
	if not is_boosting:
		stamina_regen_timer += delta
		if stamina_regen_timer >= stamina_regen_delay and stamina < max_stamina:
			stamina = clamp(stamina + stamina_regen_rate * delta, 0, max_stamina)

	emit_signal("vitals_changed", oil, stamina, fuel)


func set_oil(value: float):
	oil = clamp(value, 0, max_oil)
	emit_signal("vitals_changed", oil, stamina, fuel)

func set_stamina(value: float):
	stamina = clamp(value, 0, max_stamina)
	emit_signal("vitals_changed", oil, stamina, fuel)

func set_fuel(value: float):
	fuel = clamp(value, 0, max_fuel)
	emit_signal("vitals_changed", oil, stamina, fuel)

func apply_oil_damage(amount: float) -> void:
	oil = clamp(oil - amount, 0, max_oil)
	drain_stamina(stamina_drain_from_hit)
	#print("New oil:", oil)
	if oil <= 0:
		print("Oil depleted. Destroying entity.")

func drain_stamina(amount: float):
	stamina = clamp(stamina - amount, 0, max_stamina)
	stamina_regen_timer = 0.0  # Reset regen delay
	emit_signal("vitals_changed", oil, stamina, fuel)
