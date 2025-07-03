extends CharacterBody2D

var maxSpeed = 100 * 1.5
var lastDirection := Vector2(1, 0)
var playerState = "idle"

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "jump", "crouch")
	velocity = direction * maxSpeed
	move_and_slide()

	if direction == Vector2.ZERO:
		playerState = "idle"
	else:
		playerState = "walking"
		lastDirection = direction

	play_walk_animation(direction)

func play_walk_animation(direction):
	if playerState == "idle":
		if lastDirection.x >= 0:
			$AnimatedSprite2D.play("idle_right")
		else:
			$AnimatedSprite2D.play("idle_left")
	elif playerState == "walking":
		if direction.y < 0:
			$AnimatedSprite2D.play("jump")
		elif direction.y > 0:
			$AnimatedSprite2D.play("crouch")
		elif direction.x > 0:
			$AnimatedSprite2D.play("move_right")
		elif direction.x < 0:
			$AnimatedSprite2D.play("move_left")
