extends Node
@export var flip = false
export var restart = false
export var phase = 0
export var method_call_array = []

func _saving()-> void:
	var file = File.new()
	if(file.file_exists(Stats.file)):
		var error = file.open(Stats.file, File.READ)
		if error == OK:
			var data = {
			"name" : Stats.player_name,
			"mage_finished" : Stats.mage_finished,
			"knight_finished" : Stats.knight_finished,
			"dragon_finished" : Stats.dragon_finished,
			"falling_finished" : Stats.falling_finished,
			"skeleton_finished" : Stats.skeleton_finished,
			"final_boss_finished" : Stats.final_boss_finished,
			"map_slime_position" : Stats.map_slime_position,
			"map_slime_location" : Stats.map_slime_location,
			"weapon_one" : Stats.proj_1,
			"weapon_two" : Stats.proj_2
			}
			file.open(Stats.file, File.WRITE)
			file.store_var(data)
			file.close()
	else:
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
