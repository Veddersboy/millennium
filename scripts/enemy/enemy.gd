extends CharacterBody2D
class_name Enemy

@onready var animations : AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine : EnemyStateMachine = $state_machine_enemy

@onready var idle_state : IdleEnemy = $state_machine_enemy/idle
@onready var move_state : MoveEnemy = $state_machine_enemy/move
@onready var fall_state : FallEnemy = $state_machine_enemy/fall

@onready var health_component: EnemyHealthComponent = $EnemyHealthComponent

@export var gravity : float = 1000.0
@export var maxSpeed : float = 100.0
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
		attack_area.set_meta("damage", 1.0) # Example damage value

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _on_detection_area_body_entered(body: Node2D) -> void:
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
	
func apply_damage(amount: float) -> void:
	health_component.take_damage(amount)
	print("Enemy took ", amount, " damage!")
