extends Node

var jump_pressed := false
var jump_released := false
var jump_held := false
var dash_pressed := false
var attack_pressed := false

var direction := Vector2.ZERO

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("jump"):
		jump_pressed = true
		jump_held = true
	if event.is_action_released("jump"):
		jump_held = false
		jump_released = true
	if event.is_action_pressed("dash"):
		dash_pressed = true
	if event.is_action_pressed("attack"):
		attack_pressed = true

func _process(_delta):
	direction.x = Input.get_axis("move_left","move_right")

func reset():
	jump_pressed = false
	jump_released = false
	dash_pressed = false
	attack_pressed = false
