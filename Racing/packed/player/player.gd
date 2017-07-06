extends RigidBody2D
var speed = 0
var turn_speed = 5
var _max_speed = 500
var _acceleration = 0
var _direction = 0
func _ready():
	connect("body_enter",self,"_on_body_enter")
	set_process(true)
	set_process_input(true)
func _input(event):
	_direction = 0
	if(event.is_action("ui_left")):
		_direction = -1
	if(event.is_action("ui_right")):
		_direction = 1
	if(event.is_action_released("ui_left") or event.is_action_released("ui_right")):
		_direction = 0
func _process(delta):
	speed += _acceleration
	speed = min(speed,_max_speed)
	if(speed < _max_speed):
		_acceleration += delta
	set_pos(get_pos() + Vector2(_direction * turn_speed,0))
func _on_body_enter(other):
	if(other.is_in_group("enemy")):
		other.hit_by_player()
	speed = 0
	set_process(false)