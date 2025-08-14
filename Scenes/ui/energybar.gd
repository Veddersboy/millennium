extends Control

@export
var heart := preload("res://assets/heart.tres")
var emptyHeart := preload("res://assets/emptyHeart.tres")
var currentHealthShown : int = 1

@onready
var energybar := $Bar
@onready
var heartObj := $EmptyHeart

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initiate amount of maxHealth and current health according to player stats
	loadEnergy(1, 1)
	
func loadEnergy(maxEnergy, currentEnergy) -> void:
	#Ensures no leftover children are present
	energybar.max_value = maxEnergy
	energybar.value = currentEnergy

func update_energy(value) -> void:
	energybar.value = value

func update_maxHealth(value : int) -> void:
	energybar.max_value = value
