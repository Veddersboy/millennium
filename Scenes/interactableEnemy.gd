extends StateEnemy
class_name InteractableEnemy

@export var ignite_key : String = "ignite"

func enter():
	if enemy.has_node("InteractArea"):
		enemy.get_node("InteractArea").monitoring = true

func process_input(event: InputEvent) -> StateEnemy:
	if Input.is_action_just_pressed(ignite_key) and enemy.player_chase:
		return enemy.state_machine.get_state("burn") # switch to Burn state
	return null
