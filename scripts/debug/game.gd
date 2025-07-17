extends Node2D

@onready 
var debug_overlay = $DebugOverlay
@onready 
var player = $player

func _ready():
	debug_overlay.player = player
	debug_overlay.drawer.player = player
	print(player)
