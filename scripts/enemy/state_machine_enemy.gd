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
	if new_state == current_state:
		return
	current_state.exit()
	current_state = new_state
	current_state.enter()

func process_physics(delta: float) -> void:
	current_state.physics_process(delta)

func process_frame(delta: float) -> void: 
	current_state.process(delta)
