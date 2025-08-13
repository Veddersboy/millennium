extends State
class_name Death

func enter():
	super()
	parent.animations.play("death")
	parent.velocity = Vector2.ZERO

func exit():
	pass

func process_input(input: Node) -> State:
	return null

func process_physics(delta) -> State:
	parent.velocity = Vector2.ZERO
	return null
