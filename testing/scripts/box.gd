extends RigidBody2D

var _player = null
var _speed_factor = 0.5

func _ready():
	_player = get_node("../player")
	add_to_group("enemy")
	set_process(true)
