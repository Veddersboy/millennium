extends State
class_name attack

@export
var attack_damage: float = 1.0
@export 
var attack_range: float = 45.0
@export 
var attack_duration: float = 0.4 ##Shorter than 0.4s cuts the current animation
@export
var attack_movement_multiplier = 1

var attack_timer: float = 1.0
var has_attacked: bool = false

func enter():
	super()
	attack_timer = attack_duration
	has_attacked = false
	print("Entereda")
	if parent.has_node("AttackArea"):
		var attack_area = parent.get_node("AttackArea")
		_position_attack_area(attack_area)
		attack_area.base_attack()
		parent.animations.play("base_attack")
		parent.attack_area.monitoring = true
		
		if not attack_area.area_entered.is_connected(_on_attack_area_entered):
			attack_area.area_entered.connect(_on_attack_area_entered)
		
		# Manually checking areas
		#for overlapping_area in attack_area.get_overlapping_areas():
			#if overlapping_area.is_in_group("enemy_hurtbox") or overlapping_area.is_in_group("enemies"):
				#_on_attack_area_entered(overlapping_area)

func exit():
	if parent.has_node("AttackArea"):
		parent.get_node("AttackArea").monitoring = false

func process_input(input: Node) -> State:
	if input.jump_pressed && parent.is_on_floor():
		return parent.jump_state
	return null

func process_physics(delta) -> State:
	attack_timer -= delta
	
	parent.animations.flip_h = input.direction.x == -1 if input.direction.x != 0 else parent.animations.flip_h
	
	parent.velocity.x = move_toward(parent.velocity.x, input.direction.x * parent.maxSpeed * attack_movement_multiplier, parent.acceleration * delta)
	parent.velocity.y += parent.gravity * delta
	
	parent.move_and_slide()
	
	if attack_timer <= 0.0:
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

func _on_attack_area_entered(area):
	if has_attacked:
		return

	
	if area.is_in_group("enemies") or area.is_in_group("enemy_hurtbox"):
		var enemy_node = area
		if area.is_in_group("enemy_hurtbox"):
			enemy_node = area.get_parent()
		if enemy_node.has_method("apply_damage"):
			enemy_node.apply_damage(attack_damage, parent.global_position)
			print("Player dealt ", attack_damage, " damage to enemy: ", enemy_node.name)
			has_attacked = true
			_create_hit_effect(area.global_position)

	if area.is_in_group("enemies"):
		if area.has_method("apply_damage"):
			area.apply_damage(attack_damage)

	has_attacked = true
	
	if area.is_in_group("enemy_hurtbox"):
		print("Attack hit detected on: ", area.get_parent().name)
		var enemy = area.get_parent()
		if enemy.has_node("HealthComponent"):
			enemy.get_node("HealthComponent").take_damage(attack_damage)
			has_attacked = true
			
			_create_hit_effect(area.global_position)

func _create_hit_effect(position: Vector2):
	print("Hit enemy for ", attack_damage, " hearts!")
