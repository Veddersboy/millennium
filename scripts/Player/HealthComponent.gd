extends Node2D
class_name HealthComponent

@export var max_hearts: int = 3
@export var starting_hearts: float = 3.0

var current_hearts: float
var is_invulnerable: bool = false
var invulnerability_duration: float = 1.0

signal health_changed(current_hearts: float, max_hearts: int)
signal health_depleted
signal took_damage(damage: float)

func _ready():
	current_hearts = starting_hearts
	health_changed.emit(current_hearts, max_hearts)

func take_damage(damage: float) -> bool:
	if is_invulnerable or current_hearts <= 0:
		return false
	
	current_hearts = max(0, current_hearts - damage)
	took_damage.emit(damage)
	health_changed.emit(current_hearts, max_hearts)
	
	if current_hearts <= 0:
		health_depleted.emit()
		return true
	
	start_invulnerability()
	return true

func heal(amount: float):
	current_hearts = min(max_hearts, current_hearts + amount)
	health_changed.emit(current_hearts, max_hearts)

func start_invulnerability():
	is_invulnerable = true
	var timer = get_tree().create_timer(invulnerability_duration)
	timer.timeout.connect(_on_invulnerability_ended)

func _on_invulnerability_ended():
	is_invulnerable = false

func get_current_hearts() -> float:
	return current_hearts

func is_alive() -> bool:
	return current_hearts > 0
