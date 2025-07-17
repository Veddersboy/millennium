extends CanvasLayer
class_name DebugOverlay

var debug_enabled := false

@onready var label := $Panel/Label
@onready var drawer := $DebugDrawer

var player : Player
var label_text := ""

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug"): #F3
		print("hi")
		debug_enabled = !debug_enabled
		drawer.debug = debug_enabled

func _process(_delta):
	visible = debug_enabled
	if not visible:
		return
	
	label_text = "=== DEBUG INFO ===\n"
	if player:
		label_text = player_debug(label_text)
	else:
		label_text += "No player found\n"
	
	label.text = label_text

func player_debug(label : String) -> String:
	var velocity = player.velocity
	label += "State: %s\n" % player.state_machine.current_state.name
	label += "Velocity: (%.2f, %.2f)\n" % [velocity.x, velocity.y]
	label += "Has Dash?: " + str(player.has_dash) + "\n"
	label += "Dash Timer: %.3f\n" % player.dash_CD_counter
	label += "Is On Floor: %s\n" % str(player.is_on_floor())
	return label
