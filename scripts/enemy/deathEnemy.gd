extends StateEnemy
class_name DeathEnemy

@export var interact_area_path: NodePath
@onready var interact_area: Area2D = get_node(interact_area_path)

var player_nearby: Node = null

func enter():
	super()
	enemy.animations.play("death")
	enemy.z_index = -1
	if enemy.has_node("DamageArea"):
		enemy.get_node("DamageArea").remove_from_group("enemy_attacks")
	if enemy.has_node("Hurtbox"):
		enemy.get_node("Hurtbox").remove_from_group("enemy_attacks")
	player_nearby = null

func process_input(event: InputEvent) -> StateEnemy:
	if player_nearby and event.is_action_pressed("interact"):
		return enemy.state_machine.get_state("burn")
	return null
