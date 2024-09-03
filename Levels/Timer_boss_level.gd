extends Timer
var ammo_packs = load("res://Levels/basic_items/ammo.tscn")

var x_range_min
var x_range_max
var y_range_min
var y_range_max

func _on_Timer_timeout():
	randomize()
	var a = ammo_packs.instance()
	a.position = Vector2(rand_range(x_range_min,x_range_max), rand_range(y_range_min,y_range_max))
	add_child(a)
	wait_time = rand_range(8,10)

