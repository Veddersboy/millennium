extends Node2D
class_name EnemyHealthComponent

@export var max_health: float = 3.0
var current_health: float

signal health_changed(current_health: float, max_health: float)
signal died

func _ready():
	current_health = max_health
	health_changed.emit(current_health, max_health)

func take_damage(amount: float) -> bool:
	if current_health <= 0:
		return false

	current_health = max(current_health - amount, 0)
	health_changed.emit(current_health, max_health)

	if current_health <= 0:
		died.emit()
		return true

	return true

func heal(amount: float):
	current_health = min(current_health + amount, max_health)
	health_changed.emit(current_health, max_health)
