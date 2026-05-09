class_name HealthComponent
extends Node


@export var maxHealth : float
var health : float
signal dead
@export var healthBar : ProgressBar

func ready_tick() -> void:
	health = maxHealth
	if healthBar != null:
		healthBar.max_value = maxHealth
	
func tick() -> void:
	if health == 0:
		dead.emit()
	if healthBar != null:
		healthBar.value = health
	
func damage(value:float) -> void:
	health -= value
	
func heal(value:float) -> void:
	health += value
	
