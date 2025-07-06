extends CharacterBody2D

var GRAVITY = 1000.0

var jump_velocity = -400.0
var jump_cut_multiplier = .05
var jump_while_crouch = .2

var crouch_velocity = 0

var maxSpeed = 100 * 1.5
var lastDirection := Vector2(1, 0)

enum player_state{ IDLE, RUN, JUMP, FALL, CROUCH}
var state = player_state.IDLE

var playerState = "idle"

func _physics_process(delta):
	var direction := Vector2(0,0)
	
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("jump", "crouch")
	
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
	
	# Small jump
	if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y *= jump_cut_multiplier
	
	
	
	if direction.x != 0:
		lastDirection.x = direction.x
	
	# Jump, Crouch, and run physics.
	if not is_on_floor():
		if velocity.y < 0:
			state = player_state.JUMP
		else:
			state = player_state.FALL
	elif Input.is_action_pressed("crouch"):
		state = player_state.CROUCH
	elif direction != Vector2.ZERO:
		state = player_state.RUN
	else:
		state = player_state.IDLE
	
	move_and_slide()
	play_walk_animation()

func play_walk_animation():
	$AnimatedSprite2D.flip_h = lastDirection.x < 0
	
	if Input.is_action_just_pressed("attack"):
		$AnimatedSprite2D.play("base_attack")
		return
	
	match state:
		player_state.IDLE:
			$AnimatedSprite2D.play("idle_right")
		player_state.RUN:
			$AnimatedSprite2D.play("move_right")
		player_state.JUMP:
			$AnimatedSprite2D.play("jump")
		player_state.FALL:
			$AnimatedSprite2D.play("fall")
		player_state.CROUCH:
			$AnimatedSprite2D.play("crouch")
		_:
			$AnimatedSprite2D.play("idle_right") # Default
