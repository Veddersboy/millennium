extends State
class_name Move

@export
var maxSpeed = 150
@export
var minSpeed = 0.005
@export
var acceleration = 1800
@export
var friction = 2000

func enter():
	parent.animations.play("move_right")

func process_physics(delta):
	#State Switches
	if !parent.is_on_floor():
		parent.state_machine.change_state(parent.fall_state)
		return
	

	#Velocity application if state remains
	var input_dir = Input.get_axis("move_left", "move_right")
	if input_dir == 0:
		if abs(parent.velocity.x) < minSpeed:
			print("Calling Idle")
			parent.state_machine.change_state(parent.idle_state)
			return
		parent.velocity.x = move_toward(parent.velocity.x, 0, friction * delta)
	else:
		parent.velocity.x = move_toward(parent.velocity.x, input_dir * maxSpeed, acceleration * delta)
	parent.move_and_slide()
