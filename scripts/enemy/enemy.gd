extends CharacterBody2D
class_name Enemy

@onready var animations : AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine : EnemyStateMachine = $state_machine_enemy

@onready var idle_state : IdleEnemy = $state_machine_enemy/idle
@onready var move_state : MoveEnemy = $state_machine_enemy/move
@onready var fall_state : FallEnemy = $state_machine_enemy/fall

@export var gravity : float = 1000.0
@export var maxSpeed : float = 100.0
@export var acceleration : float = 1800.0
@export var player_chase : bool = false
@export var player : Node2D = null

func _ready() -> void:
	state_machine.init(self)

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
