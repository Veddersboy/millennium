extends Area2D
class_name PlayerAttackArea

@onready
var attackSprite := $AttackSprites
@onready
var timer := $ActiveTime
@onready
var collision : CollisionShape2D = $CollisionShape2D

var currentAtkDmg : float = 0.0
var attackTime : float = 0.2
var attackList = []



func _ready() -> void:
	timer.timeout.connect(_attack_timeout)
	if not area_entered.is_connected(_on_attack_area_entered):
		area_entered.connect(_on_attack_area_entered)
	monitoring = false

func play_attack(animation : String, _attackDamage : float, _attackTime : float) -> void:
	attackList.clear()
	currentAtkDmg = _attackDamage
	attackTime = _attackTime
	attackSprite.stop()
	attackSprite.play("slash")
	timer.start(attackTime)
	monitoring = true
	
	##debug
	collision.debug_color = Color.hex(0xb300006b)
	
	## Manually checking areas -- fixes case where areabox is not set to false
	## (E.g) a new attack starts during a previous attack
	for overlapping_area in get_overlapping_areas():
		if overlapping_area.is_in_group("enemy_hurtbox") or overlapping_area.is_in_group("enemies"):
			_on_attack_area_entered(overlapping_area)
	

func rotate_sprite_left(toLeft : bool) -> void:
	attackSprite.flip_h = toLeft

func _on_attack_area_entered(area):
	if attackList.has(area):
		return
	
	if area.is_in_group("enemies") or area.is_in_group("enemy_hurtbox"):
		var enemy_node = area
		if area.is_in_group("enemy_hurtbox"):
			enemy_node = area.get_parent()
		if attackList.has(enemy_node):
			return
		if enemy_node.has_method("apply_damage"):
			attackList.append(enemy_node)
			enemy_node.apply_damage(currentAtkDmg, global_position - position)
			print("Player dealt ", currentAtkDmg, " damage to enemy: ", enemy_node.name)
			#has_attacked = true
			_create_hit_effect(area.global_position)

	if area.is_in_group("enemies") && not attackList.has(area):
		if area.has_method("apply_damage"):
			attackList.append(area)
			print("MISC APPLY")
			area.apply_damage(currentAtkDmg)

	#has_attacked = true
	
	if area.is_in_group("enemy_hurtbox"):
		print("Attack hit detected on: ", area.get_parent().name)
		var enemy = area.get_parent()
		if enemy.has_node("HealthComponent"):
			enemy.get_node("HealthComponent").take_damage(currentAtkDmg)
			#has_attacked = true
			
			_create_hit_effect(area.global_position)

func _create_hit_effect(position: Vector2):
	print("Hit enemy for ", currentAtkDmg, " hearts!")

func _attack_timeout() -> void:
	monitoring = false
	##debug
	collision.debug_color = Color.hex(0x0099b36b)
	pass
