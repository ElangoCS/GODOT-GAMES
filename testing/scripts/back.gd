extends Sprite

onready var mod_jumpandrun = get_node("../mod_jump")
onready var player = get_node("../player")
var _ypos = 0
func _ready():
	mod_jumpandrun.ENABLED = true 			# Enable or disable the controller (true)
	mod_jumpandrun.GRAVITY = 2000 			# Gravity (2000)
	mod_jumpandrun.WALK_SPEED_MAX = 400 	# Max speed (400)
	mod_jumpandrun.WALK_SPEED_UP = 8 		# Acceleration (8)
	mod_jumpandrun.WALK_SPEED_UP_AIR = 4	# Acceleration in the air (4)
	mod_jumpandrun.WALK_SPEED_DOWN = 15		# Slowdown (15)
	mod_jumpandrun.JUMP_HEIGHT = 800		# Jump height (800)
	mod_jumpandrun.JUMPS = 2				# Jump (1), doublejump (2) or disable jumping (0) 
	mod_jumpandrun.ROTATE_CHAR = true		# Rotate char to walking direction (true)
	mod_jumpandrun.JUMP_FALLING = false		# enable jumps after falling down somewhere (false)
	
	mod_jumpandrun.enable( get_node("KinematicBody2D") )
	set_process(true)
func _process(delta):
    #_ypos -= player.speed * delta
    #set_region_rect(Rect2(0,_ypos,640,960))*/
	

	