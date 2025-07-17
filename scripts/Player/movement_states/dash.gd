extends State
class_name dash

var dash_time: float = 0
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
func enter():
	super()
	dash_time = 0
	parent.animations.play("dash")
	parent.velocity = input.direction.normalize() * parent.dash_speed
	
	

func process_physics(delta) -> State:
	dash_time += delta
	if dash_time > parent.dash_length:
		return parent.idle_state #Consider making a function to decide transition state within state manager or something
	parent.move_and_slide()
	return null

func exit():
	parent.has_dash = false
