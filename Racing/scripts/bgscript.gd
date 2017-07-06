extends Sprite

onready var player = get_node("../player")
var _ypos = 0
func _ready():
    set_process(true)
func _process(delta):
    _ypos -= player.speed * delta
    set_region_rect(Rect2(0,_ypos,640,960))

