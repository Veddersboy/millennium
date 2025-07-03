extends CharacterBody2D

var GRAVITY = 1000.0

var jump_velocity = -400.0
var jump_cut_multiplier = .05
var jump_while_crouch = .2

var crouch_velocity = 0

var maxSpeed = 100 * 1.5
var lastDirection := Vector2(1, 0)
var playerState = "idle"

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "", "")
	var direction_up_and_down = Input.get_vector("jump", "crouch", "", "")
	
	if is_on_floor():
		if Input.is_action_pressed("crouch"):
			velocity.x = crouch_velocity
		else:
			velocity.x = direction.x * maxSpeed
	else:
		velocity.x = direction.x * maxSpeed
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y *= jump_cut_multiplier
	
	move_and_slide()
	
	if direction == Vector2.ZERO:
		playerState = "idle"
	else:
		playerState = "walking"
		lastDirection = direction
	
	play_walk_animation(direction, direction_up_and_down)

func play_walk_animation(direction: Vector2, vertical_input: Vector2):
	var flip = direction.x < 0 if direction.x != 0 else lastDirection.x < 0
	$AnimatedSprite2D.flip_h = flip
	
	if Input.is_action_just_pressed("attack"):
		$AnimatedSprite2D.play("base_attack")
	
	if not is_on_floor():
		if velocity.y < 0:
			$AnimatedSprite2D.play("jump")
		else:
			$AnimatedSprite2D.play("fall")
	elif Input.is_action_pressed("crouch"):
		$AnimatedSprite2D.play("crouch")
	elif direction == Vector2.ZERO:
		$AnimatedSprite2D.play("idle_right")
	else:
		$AnimatedSprite2D.play("move_right")
	
