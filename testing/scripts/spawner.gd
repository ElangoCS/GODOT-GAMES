extends Timer
var spawn_items = [
	preload("res://boxes.tscn")
]
func _ready():
	connect("timeout",self,"_on_timeout")
func _on_timeout():
	var r = rand_range(0,spawn_items.size())
	var item = spawn_items[r].instance()
	r = rand_range(0,200)
	item.set_pos(Vector2(r, -1000))        
	get_parent().add_child(item)
