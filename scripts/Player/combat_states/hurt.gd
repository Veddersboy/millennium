extends State
class_name hurt

@export var hurt_duration: float = .25
@export var knockback_force: float = 250.0

var hurt_timer: float = 0.0
var knockback_direction: Vector2 = Vector2.ZERO
var original_color: Color

func enter():
	super()
	hurt_timer = hurt_duration
	original_color = parent.animations.modulate
	
	var tween = create_tween()
	tween.tween_method(_flash_red, 0.0, 1.0, 0.1)
	tween.tween_callback(_start_flicker)
	
	if parent.animations.sprite_frames.has_animation("hurt"):
		parent.animations.play("hurt")

func _flash_red(intensity: float):
	parent.animations.modulate = original_color.lerp(Color.RED, intensity)

func _start_flicker():
	var flicker_tween = create_tween()
	flicker_tween.set_loops()
	flicker_tween.tween_method(_set_alpha, 0.3, 1.0, 0.1)
	flicker_tween.tween_method(_set_alpha, 1.0, 0.3, 0.1)
	
	var stop_timer = get_tree().create_timer(hurt_duration - 0.1)
	stop_timer.timeout.connect(func(): flicker_tween.kill())

func _set_alpha(alpha: float):
	var color = parent.animations.modulate
	color.a = alpha
	parent.animations.modulate = color

func exit():
	parent.animations.modulate = original_color

func process_input(input: Node) -> State:
	return null

func process_physics(delta) -> State:
	hurt_timer -= delta
	
	if knockback_direction != Vector2.ZERO:
		parent.velocity.x = knockback_direction.x * knockback_force
		# knockback_force = max(0, knockback_force - 400 * delta)
	
	parent.velocity.y += parent.gravity * delta
	parent.move_and_slide()
	
	if hurt_timer <= 0.0:
		if parent.is_on_floor():
			if input.direction.x != 0:
				return parent.move_state
			else:
				return parent.idle_state
		else:
			return parent.fall_state
	
	return null

func set_knockback_direction(direction: Vector2):
	knockback_direction = direction.normalized()
