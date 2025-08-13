extends Node
class_name StateMachine

@export var starting_state: State
var current_state: State

func init(p: Player):
	for child in get_children():
		if child is State:
			child.parent = p
			child.input = p.input
	change_state(starting_state)

func change_state(new_state: State):
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()

func process_input(input: Node):
	var new_state = current_state.process_input(input)
	if new_state:
		change_state(new_state)

func process_physics(delta: float):
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_frame(delta: float):
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
