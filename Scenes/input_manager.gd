extends Node

var jump_pressed := false
var jump_released := false
var jump_held := false
var direction := Vector2.ZERO

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("jump"):
		jump_pressed = true
		jump_held = true
	if event.is_action_released("jump"):
		jump_held = false
		jump_released = true

func _process(_delta):
	direction = Input.get_vector("move_left","move_right","look-up","crouch")

func reset():
	jump_pressed = false
	jump_released = false
