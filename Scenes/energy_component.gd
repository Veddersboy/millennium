extends Node
class_name EnergyComponent

@export var max_energy: float = 100.0
@export var starting_energy: float = 50.0

var current_energy: float

signal energy_changed(current_energy: float, max_energy: float)

func _ready() -> void:
	current_energy = starting_energy
	energy_changed.emit(current_energy, max_energy)

func add_energy(amount: float) -> void:
	current_energy = clamp(current_energy + amount, 0, max_energy)
	energy_changed.emit(current_energy, max_energy)

func drain_energy(amount: float) -> void:
	current_energy = clamp(current_energy - amount, 0, max_energy)
	energy_changed.emit(current_energy, max_energy)

func get_current_energy() -> float:
	return current_energy

func is_full() -> bool:
	return current_energy >= max_energy

func is_empty() -> bool:
	return current_energy <= 0
