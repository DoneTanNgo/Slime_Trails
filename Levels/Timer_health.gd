extends Timer
var health_packs = load("res://Levels/basic_items/health_pack.tscn")

var x_range_min
var x_range_max
var y_range_min
var y_range_max

func _on_Timer2_timeout():
	randomize()
	var h = health_packs.instance()
	h.position = Vector2(rand_range(x_range_min,x_range_max), rand_range(y_range_min,y_range_max))
	add_child(h)
	wait_time = rand_range(20,30)
