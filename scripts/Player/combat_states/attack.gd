extends State
class_name attack

@export
var attack_damage: float = 1.0
@export 
var attack_range: float = 45.0
@export 
var attackState_duration: float = 0.1 ##Shorter than 0.4s cuts the current animation
@export
var hitboxDuration: float = 0.2 ## Duration the hitbox will check for
@export
var attack_movement_multiplier = .8

var _attack_timer: float = 0.0

func enter():
	super()
	_attack_timer = attackState_duration
	if parent.has_node("AttackArea"):
		var attack_area = parent.get_node("AttackArea")
		_position_attack_area(attack_area)
		attack_area.play_attack("slash", attack_damage, hitboxDuration)
		parent.animations.play("base_attack")

func exit():
	pass

func process_input(input: Node) -> State:
	if input.jump_pressed && parent.is_on_floor():
		return parent.jump_state
	return null

func process_physics(delta) -> State:
	_attack_timer -= delta
	
	parent.animations.flip_h = input.direction.x == -1 if input.direction.x != 0 else parent.animations.flip_h
	
	parent.velocity.x = move_toward(parent.velocity.x, input.direction.x * parent.maxSpeed * attack_movement_multiplier, parent.acceleration * delta)
	parent.velocity.y += parent.gravity * delta
	
	parent.move_and_slide()
	
	if _attack_timer <= 0.0:
		if parent.is_on_floor():
			if input.direction.x != 0 && abs(parent.velocity.x) > parent.minSpeed:
				return parent.move_state
			else:
				return parent.idle_state
		else:
			return parent.fall_state
	
	return null

func _position_attack_area(attack_area: Area2D):
	var facing_direction = Vector2.RIGHT
	if parent.animations.flip_h:
		facing_direction = Vector2.LEFT
	
	if sign(attack_area.position.x) != facing_direction.x:
		attack_area.position.x = -attack_area.position.x
		attack_area.scale.x = -attack_area.scale.x
		# attack_area.attackSprite.flip_v = !attack_area.attackSprite.flip_v
		
	# attack_area.rotate_sprite_left(parent.animations.flip_h)
