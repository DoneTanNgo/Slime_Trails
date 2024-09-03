extends Position2D
var ammo_packs = load("res://Levels/basic_items/ammo.tscn")
var can_spawn = false
var wait_time = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _process(delta):
	while(can_spawn && wait_time):
		spawn_ammo()

func spawn_ammo()-> void:
	var a = ammo_packs.instance()
	a.transform = self.transform
	owner.add_child(a)
	wait_time = false
	yield(get_tree().create_timer(3),"timeout")
	wait_time = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
