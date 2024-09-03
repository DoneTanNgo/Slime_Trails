extends Control



func _ready():
	pass
	
func _process(delta):
	$HBoxContainer/ProgressBar.value = EnemeyStats.current_Hp
	$HBoxContainer/ProgressBar.max_value = EnemeyStats.max_Hp
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
