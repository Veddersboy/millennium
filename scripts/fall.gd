extends State
class_name Fall

func enter():
	parent.animations.play("fall")

func process_physics(delta):
	parent.velocity.y += parent.GRAVITY * delta

	if parent.is_on_floor():
		parent.state_machine.change_state(parent.idle_state)

	parent.move_and_slide()
