extends CanvasLayer
class_name PlayerUI

var player : CharacterBody2D

@onready
var healthbar := $Healthbar
@onready
var energybar := $Energybar

func initUI(_player : CharacterBody2D) -> void:
	player = _player
	healthbar.loadHealth(player.health_component.max_hearts, player.health_component.current_hearts)
	player.health_changed.connect(_updateHealthbar)
	player.player_died.connect(_updateOnDeath)
	energybar.loadEnergy(100,10)

func _updateHealthbar(currentHP, maxHP ) -> void:
	healthbar.loadHealth(maxHP, currentHP)

func _updateOnDeath() -> void:
	healthbar.update_health(0)
