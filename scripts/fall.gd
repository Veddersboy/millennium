extends State
class_name Fall

@export
var idle_state: State

func enter():
	super()
	parent.animations.play("fall")

func process_physics(delta) -> State:
	parent.velocity.y += parent.GRAVITY * delta

	if parent.is_on_floor():
		return idle_state

	parent.move_and_slide()
	return null
