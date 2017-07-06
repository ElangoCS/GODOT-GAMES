extends RigidBody2D
var _player = null
var _speed_factor = 1
func _ready():
	_player = get_node("../player")
	add_to_group("block")
	set_process(true)
func _process(delta):
	set_pos(get_pos() + Vector2(0, _player.speed * _speed_factor * delta))
func hit_by_player():
	set_process(false)