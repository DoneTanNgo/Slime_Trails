extends Control
signal results


func _ready():
	connect("results",self,"_results")

func _results(res) -> void:
	if(res):
		$Popup/VBoxContainer/Panel/Defeat.visible = false
		get_tree().paused = true
		$Popup.visible = true
	else:
		$Popup/VBoxContainer/Panel/Victory.visible = false
		get_tree().paused = true
		$Popup.visible = true

func _on_Try_Again_pressed():
	get_tree().paused = false
	$Popup.visible = false
	get_tree().reload_current_scene()
	Stats.ammo = 20


func _on_Menu_pressed():
	get_tree().paused = false
	match Stats.map_slime_location:
		0:
			Transition.change_scene("res://Menu/Level_map_1.tscn")
		1:
			Transition.change_scene("res://Menu/Level_map_2.tscn")
		_:
			Transition.change_scene("res://Menu/Level_map_1.tscn")


func _on_Exit_pressed():
	get_tree().quit()


func _on_Player_pressed():
	get_tree().paused = false
	Transition.change_scene("res://PlayerHolder/Player_customize.tscn")
