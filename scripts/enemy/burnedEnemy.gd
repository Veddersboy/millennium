extends StateEnemy
class_name BurnedEnemy

@export var burn_duration: float = 2.0
@export var burn_energy_gain: float = 5

var burn_timer: float = 0.0
var player_ref: Node = null

func set_player(player: Node) -> void:
	player_ref = player

func enter():
	super()
	burn_timer = burn_duration
	enemy.animations.play("burn")
	#if player_ref:
		#player_ref.add_energy(burn_energy_gain)

func process_frame(delta: float) -> StateEnemy:
	burn_timer -= delta
	if player_ref:
		player_ref.add_energy(burn_energy_gain * delta)
	if burn_timer <= 0:
		enemy.queue_free()
	return null
