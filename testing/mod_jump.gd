extends Node

# Description:
# A small and powerful jump and run engine extension. 
# Control you character with the keys you've setup in the keymap
# With many options (doublejump, jump after fall, jump height, walking speed, acceleration, slowdown,...)
 
# Usage:
#	# Simple usage
#	#get_node("/root/mod_jumpandrun").enable( get_node("KinematicBody2D") )
#	
#	# Change options
#	var mod_jumpandrun = get_node("/root/mod_jumpandrun")
#
#	mod_jumpandrun.ENABLED = true			# Enable or disable the controller (true)
#	mod_jumpandrun.GRAVITY = 2000 			# Gravity (2000)
#	mod_jumpandrun.WALK_SPEED_MAX = 400 	# Max speed (400)
#	mod_jumpandrun.WALK_SPEED_UP = 8 		# Acceleration (8)
#	mod_jumpandrun.WALK_SPEED_UP_AIR = 4	# Acceleration in the air (4)
#	mod_jumpandrun.WALK_SPEED_DOWN = 15		# Slowdown (15)
#	mod_jumpandrun.JUMP_HEIGHT = 800		# Jump height (800)
#	mod_jumpandrun.JUMPS = 2				# Jump (1), doublejump (2) or disable jumping (0) 
#	mod_jumpandrun.ROTATE_CHAR = true		# Rotate char to walking direction (true)
#	mod_jumpandrun.JUMP_FALLING = false		# enable jumps after falling down somewhere (false)
#	
#	mod_jumpandrun.enable( get_node("KinematicBody2D") )
#	
#	# Disable controls
#	#get_node("/root/mod_jumpandrun").disable()
 
# Author (s)
# Marco Heizmann
 
# Version:
# V1.0
 
# Link:
# http://www.godotengine.de/en/script_modules/mod_jumpandrun
 
######## Test mode should always be present.
func  modtest():
	print("Module -jumpandrun- loaded")
	return true
########
 

# preset variables
var ENABLED = true			# Enable or disable the controller (true)
var GRAVITY = 2000 			# Gravity (2000)
var WALK_SPEED_MAX = 400 	# Max speed (400)
var WALK_SPEED_UP = 8 		# Acceleration (8)
var WALK_SPEED_UP_AIR = 4	# Acceleration in the air (4)
var WALK_SPEED_DOWN = 15	# Slowdown (15)
var JUMP_HEIGHT = 800		# Jump height (800)
var JUMPS = 2				# Jump (1), doublejump (2) or disable jumping (0) 
var ROTATE_CHAR = true		# Rotate char to walking direction (true)
var JUMP_FALLING = false	# enable jumps after falling down somewhere (false)


# some variables (nothing to change)
var walk_speed_cur = 0
var walk_dir = 0
var walk_dir_cur = 0
var velocity = Vector2()
var char_node
var char_on_ground = 0
var char_jumped = false
var testcounter = 1

# current movement (for example to set an animation)
var char_move_return = Vector2() # 0: stand, 1:right(x) / down(y), -1:left(x) / up(y)


# Sub func for calc movement speed
func move_action(delta):

	# speed up until max_speed is reached
	if walk_speed_cur < WALK_SPEED_MAX:
		# ground or air speed?
		if char_on_ground > 0:
			walk_speed_cur += (WALK_SPEED_UP * 100) * delta
		else:
			walk_speed_cur += (WALK_SPEED_UP_AIR * 100) * delta


# Movement process
func _fixed_process(delta):

	if ENABLED:
		velocity.y += GRAVITY * delta
	
		# If left/right key is pressed (use keymap in project settings)
		if Input.is_action_pressed("ui_left"):
			walk_dir = -1 		# Direction: left
			move_action(delta)	# Sub func for calc movement speed
	
		elif Input.is_action_pressed("ui_right"):
			walk_dir = 1 		# Direction: left
			move_action(delta)	# Sub func for calc movement speed
	
		else:
			# Slow down / break
			if walk_speed_cur > 0:
				walk_speed_cur -= (WALK_SPEED_DOWN * 100) * delta
			else:
				walk_speed_cur = 0
	
		# Check for instant direction change
		if walk_dir_cur != walk_dir:
			walk_speed_cur = 0
			walk_dir_cur = walk_dir
	
	
		# Char move direction
		velocity.x = walk_speed_cur * walk_dir
	
		# Now set motion var mit movement values
		var motion = velocity * delta
	
		# Move char
		char_node.move( motion )
	
		# If the char collides with something
		if char_node.is_colliding():
		
			# Direction of the collision
			var n = char_node.get_collision_normal()
	
			# Chara is on ground (enable jumping)
			if n.y < 0:
				char_on_ground = JUMPS
				# Enable jumping after falling down somewhere?
				if !JUMP_FALLING:
					char_jumped = false
	
			# move away from collision without slow sliding
			motion = n.slide( motion ) 
			velocity = n.slide( velocity * delta )
			velocity.y = motion.y * (JUMP_HEIGHT * 0.075) # ~60 prevent slow sliding
	
			char_node.move( motion )
	
		
		# Char is in the air
		else:
			if !char_jumped:
				char_on_ground = 0
	
		# return current movement direction
		char_move_return.x = sign(velocity.x)
		char_move_return.y = sign(velocity.y)
	
		# rotate char
		if ROTATE_CHAR:
			var rotation = walk_dir
			if !(rotation > 0) and !(rotation < 0):
				rotation = 1
			char_node.set_scale(Vector2( rotation ,1) )
	
		#print( char_move_return )


# Initialisation
func enable(node):

	char_node = node
	set_fixed_process(true)
	set_process_input(true) # watch for inputs


# Initialisation
func disable():

	set_fixed_process(false)
	set_process_input(false) # watch for inputs


# Watch for inputs
func _input(event):

	# Jump / doublejump - pressed
	if(event.is_action("ui_up") && char_on_ground > 0 && event.is_pressed() && !event.is_echo() ):
		velocity.y = -JUMP_HEIGHT
		char_jumped = true
		char_on_ground -= 1

	# Jump / doublejump - released
	if(event.is_action("ui_up") && !event.is_pressed() && !event.is_echo() ):
		if velocity.y < ( -JUMP_HEIGHT*0.5 ):
			velocity.y = -JUMP_HEIGHT*0.5
