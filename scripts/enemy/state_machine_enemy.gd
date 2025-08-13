extends Node
class_name EnemyStateMachine

var current_state : StateEnemy = null

func init(enemy: Enemy) -> void:
	for child in get_children():
		if child is StateEnemy:
			child.enemy = enemy
	current_state = enemy.idle_state
	current_state.enter()

func change_state(new_state: StateEnemy) -> void:
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()

func process_physics(delta: float):
	var new_state = current_state.physics_process(delta)
	if new_state:
		change_state(new_state)

func process_frame(delta: float):
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
