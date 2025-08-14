extends Control

@export
var heart := preload("res://assets/heart.tres")
var emptyHeart := preload("res://assets/emptyHeart.tres")
var currentHealthShown : int = 1

@onready
var healthbar := $Healthbar
@onready
var heartObj := $EmptyHeart

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initiate amount of maxHealth and current health according to player stats
	loadHealth(1, 1)
	
func loadHealth(maxHP: int, currentHP: int) -> void:
	#Ensures no leftover children are present
	var oldChildren = healthbar.get_children()
	for oldChild in oldChildren:
		oldChild.free()
	##Adds children based on specified variables
	for n in maxHP:
		healthbar.add_child(heartObj.duplicate(DUPLICATE_USE_INSTANTIATION))
	for n in range(0,currentHP):
		healthbar.get_child(n).texture = heart
	currentHealthShown = currentHP

func update_health(value : int) -> void:
	for n in healthbar.get_child_count():
		if value > n:
			healthbar.get_child(n).texture = heart
		else:
			healthbar.get_child(n).texture = emptyHeart
	currentHealthShown = value

func update_maxHealth(value : int) -> void:
	if(value < currentHealthShown):
		currentHealthShown = value
	loadHealth(value, currentHealthShown)

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
