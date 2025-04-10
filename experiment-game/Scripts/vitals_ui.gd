class_name VitalsUI
extends Control

@onready var oil_bar = $OilBar
@onready var stamina_bar = $StaminaBar
@onready var fuel_bar = $FuelBar

func update_vitals(oil: float, stamina: float, fuel: float) -> void:

	oil_bar.value = oil
	stamina_bar.value = stamina
	fuel_bar.value = fuel
	
