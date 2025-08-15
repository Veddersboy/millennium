class_name Player
extends CharacterBody2D

@onready
var animations : AnimatedSprite2D = $AnimatedSprite2D
@onready 
var state_machine = $state_machine
@onready
var input = $input_manager

@onready var idle_state = $state_machine/idle
@onready var move_state = $state_machine/move
@onready var jump_state = $state_machine/jump
@onready var fall_state = $state_machine/fall
@onready var dash_state = $state_machine/dash
@onready var attack_state = $state_machine/attack
@onready var hurt_state = $state_machine/hurt
@onready var death_state = $state_machine/death
@onready var burnBody_state = $state_machine/burnBody

@onready var interaction_area = $InteractArea

@onready var health_component: HealthComponent = $HealthComponent
@onready var energy_component: EnergyComponent = $EnergyComponent

@onready var attack_area: Area2D = $AttackArea
@onready var hurtbox: Area2D = $Hurtbox
@onready var playerUI : PlayerUI = $PlayerUI


# var lastDirection := Vector2.RIGHT
@export
var gravity = 1000.0
@export
var jump_velocity = -400.0
@export
var maxSpeed = 150.0
@export
var minSpeed = 0.005
@export
var acceleration = 1800.0
@export
var air_friction = 1000.0
@export
var friction = 1800.0
@export
var dash_speed : float = 400.0
@export
var dash_length : float = 0.2
@export
var dash_CD : float = 0.2
@export
var dash_CD_counter : float = 0.0
@export
var has_dash : bool = true

signal player_died
signal health_changed(current_hearts: float, max_hearts: int)

@export var enemy : Node2D = null
@export var enemy_inside : bool = false
@export var overlapping_enemies: Array = []

func _ready() -> void:
	state_machine.init(self)
	
	add_to_group("player")
	
	if playerUI:
		playerUI.initUI(self)
	
	if health_component:
		health_component.health_depleted.connect(_on_health_depleted)
		health_component.took_damage.connect(_on_took_damage)
		health_component.health_changed.connect(_on_health_changed)
	
	if has_node("InteractArea"):
		var interact_area = get_node("InteractArea")
		interact_area.body_entered.connect(_on_interactable_body_entered)
		interact_area.body_exited.connect(_on_interactable_body_exited)

	if hurtbox:
		hurtbox.area_entered.connect(_on_hurtbox_area_entered)

func _unhandled_input(event: InputEvent) -> void:
	pass #Handled by input_manager

func _physics_process(delta: float) -> void:
	dash_check(delta)
	state_machine.process_input(input)
	state_machine.process_physics(delta)
	handle_burn()
	input.reset()

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _on_interactable_body_entered(body: Node) -> void:
	print("Body entered:", body.name, "Groups:", body.get_groups())
	if body.is_in_group("enemies") and not overlapping_enemies.has(body):
		overlapping_enemies.append(body)
		print("Enemy entered:", body.name)

func _on_interactable_body_exited(body: Node) -> void:
	if body.is_in_group("enemies") and overlapping_enemies.has(body):
		overlapping_enemies.erase(body)
		print("Enemy left:", body.name)

func dash_check(delta):
	if has_dash:
		return
	if dash_CD_counter < dash_CD:
		dash_CD_counter += delta
		return
	if is_on_floor():
		has_dash = true
		dash_CD_counter = 0
	return

func handle_burn() -> void:
	if input.ignite_pressed:
		print("Burn pressed")
		for enemy in overlapping_enemies:
			if enemy.is_dead:
				print("Burn STATE")
				state_machine.change_state(burnBody_state)
				enemy.ignite()
				input.ignite_pressed = false
				break

func get_overlapping_enemies() -> Array:
	var enemies := []
	for area in interaction_area.get_overlapping_bodies():
		if area.is_in_group("enemies"):
			enemies.append(area)
	return enemies

func _on_health_depleted():
	"""Called when player's health reaches 0"""
	player_died.emit()
	state_machine.change_state(death_state)
	print("Player died!")

func _on_took_damage(damage: float):
	"""Called when player takes damage"""

	if state_machine.current_state != hurt_state:
		state_machine.change_state(hurt_state)

func _on_health_changed(current_hearts: float, max_hearts: int):
	"""Called when player's health changes - forward to UI"""
	health_changed.emit(current_hearts, max_hearts)

func _on_hurtbox_area_entered(area):
	"""Called when something enters player's hurtbox"""
	if area.is_in_group("enemy_attacks"):
		var damage = area.get_meta("damage", 0.5)
		var took_damage = health_component.take_damage(damage)
		if took_damage:
			print("Player took ", damage, " damage from enemy attack")
		var knockback_dir = (global_position - area.global_position).normalized()
		if state_machine.current_state == hurt_state:
			hurt_state.set_knockback_direction(knockback_dir)

func add_energy(amount: float) -> void:
	energy_component.add_energy(amount)
	print("Player energy:", energy_component.current_energy)

#var GRAVITY = 1000.0
#
#var jump_velocity = -400.0
#var jump_cut_multiplier = .05
#var jump_while_crouch = .2
#
#var crouch_velocity = 0
#
#var maxSpeed = 100 * 1.5
#var acceleration = 1800
#var friction = 2000
#var lastDirection := Vector2(1, 0)
#
#enum player_state{ IDLE, RUN, JUMP, FALL, CROUCH}
#var state = player_state.IDLE
#var playerState = "idle"
#
#var has_double_jump : bool = true
#
#var has_dash : bool = true
#var dashing : bool = false
#var dash_speed : float = 400.0
#var dash_direction := Vector2(1,0)
#var dash_on_CD : bool = false
#
#
#func _physics_process(delta):
	#var direction := Vector2(0,0)
	#
	#direction.x = Input.get_axis("move_left", "move_right")
	#direction.y = Input.get_axis("jump", "crouch")
	#
	#if direction.x != 0:
		#velocity.x = move_toward(velocity.x, direction.x * maxSpeed, acceleration * delta)
		#lastDirection.x = direction.x
	#else:
		#velocity.x = move_toward(velocity.x, 0, friction * delta)
	#
	#if !has_dash:
		#if!dash_on_CD && is_on_floor():
			#has_dash = true
	#
	#if Input.is_action_just_pressed("dash") && has_dash:
		#dash(direction)
	#
	#if dashing:
		#velocity = dash_direction
		#move_and_slide()
		#play_walk_animation()
		#return
		#
	#if is_on_floor():
		#has_double_jump = true
		#if Input.is_action_pressed("crouch"):
			#velocity.x = crouch_velocity
	#
	#if not is_on_floor():
		#if Input.is_action_just_pressed("jump"):
			#attempt_double_jump()
		#velocity.y += GRAVITY * delta
	#else: 
		#if Input.is_action_just_pressed("jump"):
			#velocity.y = jump_velocity
	#
	## Small jump
	#if Input.is_action_just_released("jump") and velocity.y < 0:
			#velocity.y *= jump_cut_multiplier
	#
	## Jump, Crouch, and run physics.
	#if not is_on_floor():
		#if velocity.y < 0:
			#state = player_state.JUMP
		#else:
			#state = player_state.FALL
	#elif Input.is_action_pressed("crouch"):
		#state = player_state.CROUCH
	#elif direction != Vector2.ZERO:
		#state = player_state.RUN
	#else:
		#state = player_state.IDLE
	#
	#move_and_slide()
	#play_walk_animation()
#
#func attempt_double_jump():
	#if has_double_jump:
		#velocity.y = jump_velocity
		#has_double_jump = false
#
#func dash(direction):
		#dashing = true
		#has_dash = false
		#dash_on_CD = true
		#$DashTime.start()
		#$AnimatedSprite2D.play("dashing")
		#$DashCD.start()
		#var vertical_input = Input.get_axis("look-up", "crouch")
		#if direction.x != 0:
			#dash_direction.x = direction.x * dash_speed
			#dash_direction.y =  vertical_input * dash_speed
		#else:
			#if vertical_input != 0:
				#dash_direction.y = vertical_input * dash_speed
				#dash_direction.x = 0
			#else: 
				#dash_direction.x = lastDirection.x * dash_speed
				#dash_direction.y = 0
		#dash_direction = dash_direction.normalized() * dash_speed
		#print("DASHING" + "directionUsed: " + str(direction.x) + ", " + str(direction.y))
		#print("  " + "direction Found" + str(Input.get_axis("move_left", "move_right")) + ", " + str(Input.get_axis("jump", "crouch")))
		#
#func _on_dash_time_timeout() -> void:
	#dashing = false
#
#func _on_dash_cd_timeout() -> void:
	#dash_on_CD = false
#
#func play_walk_animation():
	#$AnimatedSprite2D.flip_h = lastDirection.x < 0
	#
	#if Input.is_action_just_pressed("attack"):
		#$AnimatedSprite2D.play("base_attack")
		#return
	#
	#match state:
		#player_state.IDLE:
			#$AnimatedSprite2D.play("idle_right")
		#player_state.RUN:
			#$AnimatedSprite2D.play("move_right")
		#player_state.JUMP:
			#$AnimatedSprite2D.play("jump")
		#player_state.FALL:
			#$AnimatedSprite2D.play("fall")
		#player_state.CROUCH:
			#$AnimatedSprite2D.play("crouch")
		#_:
			#$AnimatedSprite2D.play("idle_right") # Default
