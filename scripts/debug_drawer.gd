extends Node2D

var debug := false
@onready var player

@export 
var vec_multiplier := 0.1

func _process(_delta):
	queue_redraw()
	
func _draw():
	if !debug:
		return
	
	var camera = get_viewport().get_camera_2d()
	if camera:
		var screen_origin = camera.get_viewport().get_visible_rect().size / 2
		var screen_velocity = screen_origin + player.velocity * 0.1
		
		draw_circle(screen_origin, 10, Color.YELLOW) #screen center
		draw_line(screen_origin, screen_velocity, Color.CYAN, 10)
	
