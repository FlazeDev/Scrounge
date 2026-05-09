class_name StaminaComponent
extends Node

@export var maxStamina : float
var stamina : float
@export var staminaBar : ProgressBar
var canRegen := false
var sTimer : float

func ready_tick() -> void:
	stamina = maxStamina
	if staminaBar != null:
		staminaBar.max_value = maxStamina
	
func tick(delta:float) -> void:
	if staminaBar != null:
		staminaBar.value = stamina
	if !canRegen:
		sTimer += delta
	if sTimer >= 2:
		sTimer = 2
		canRegen = true
	
	if stamina < maxStamina && canRegen:
		increase(0.5)
	
func reduce(value:float) -> void:
	stamina -= value
	sTimer = 0
	canRegen = false
	
func increase(value:float) -> void:
	stamina += value
