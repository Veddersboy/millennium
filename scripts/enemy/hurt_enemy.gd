extends StateEnemy
class_name HurtEnemy

@export var hurt_duration: float = 0.25
@export var knockback_force: float = 150.0

var hurt_timer: float = 0.0
var knockback_direction: Vector2 = Vector2.ZERO
var original_color: Color

func enter():
	super()
	hurt_timer = hurt_duration
	original_color = enemy.animations.modulate
	
	if enemy.animations.sprite_frames.has_animation("hurt"):
		enemy.animations.play("hurt")

func exit():
	enemy.animations.stop()

func physics_process(delta) -> StateEnemy:
	print(hurt_timer)
	hurt_timer -= delta
	
	# Apply knockback
	enemy.velocity.x = knockback_direction.x * knockback_force
	#enemy.velocity.y += enemy.gravity * delta
	
	enemy.move_and_slide()
	
	if hurt_timer <= 0.0:
		if enemy.is_on_floor():
			if enemy.player_chase:
				return enemy.move_state
			else:
				return enemy.idle_state
		else:
			return enemy.fall_state
	
	return null

func set_knockback_direction(direction: Vector2):
	knockback_direction = direction.normalized()
