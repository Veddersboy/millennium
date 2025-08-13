extends CharacterBody2D
class_name Enemy

@onready var animations : AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine : EnemyStateMachine = $state_machine_enemy

@onready var idle_state : StateEnemy = $state_machine_enemy/idle
@onready var move_state : StateEnemy = $state_machine_enemy/move
@onready var fall_state : StateEnemy = $state_machine_enemy/fall
@onready var hurt_state: StateEnemy = $state_machine_enemy/hurt

@onready var health_component: EnemyHealthComponent = $EnemyHealthComponent


@export var gravity : float = 1000.0
@export var maxSpeed : float = 80.0
@export var acceleration : float = 1800.0
@export var player_chase : bool = false
@export var player : Node2D = null

func _ready() -> void:
	add_to_group("enemies")
	state_machine.init(self)
	health_component.died.connect(_on_death)
	health_component.health_changed.connect(_on_health_changed)
	
	if has_node("Hurtbox"):
		var hurtbox_area = get_node("Hurtbox")
		hurtbox_area.add_to_group("enemy_hurtbox")
	
	if has_node("DamageArea"):
		var attack_area = get_node("DamageArea")
		attack_area.add_to_group("enemy_attacks")
		attack_area.set_meta("damage", 1.0)

func _physics_process(delta: float):
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _on_detection_area_body_entered(body: Node2D) -> void:
	
	if(body is CharacterBody2D):
		player = body
		player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		player_chase = false

func _on_health_changed(current_health: float, max_health: float):
	print("Enemy health:", current_health, "/", max_health)

func _on_death():
	print("Enemy died!")

	set_physics_process(false)
	queue_free()
	
func apply_damage(amount: float, source_position: Vector2) -> void:
	var was_alive = health_component.current_health > 0
	health_component.take_damage(amount)
	if was_alive and health_component.current_health > 0:
		print("Enemy took ", amount, " damage!")
		var knockback_dir = (global_position - source_position).normalized()
		hurt_state.set_knockback_direction(knockback_dir)
		state_machine.change_state(hurt_state)
	
