extends CanvasLayer
var is_paused = false setget set_is_paused

func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		self.is_paused = !is_paused
	
func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	$Popup.visible = is_paused


func _on_Continue_pressed():
	is_paused = false
	get_tree().paused = is_paused
	$Popup.visible = is_paused

func _on_Setting_pressed():
	$Popup/VBoxContainer/Panel/VBoxContainer/Setting/Setting.is_paused = !$Popup/VBoxContainer/Panel/VBoxContainer/Setting/Setting.is_paused

func _on_Exit_to_Menu_pressed():
	get_tree().paused = false
	match Stats.map_slime_location:
		0:
			Transition.change_scene("res://Menu/Level_map_1.tscn")
		1:
			Transition.change_scene("res://Menu/Level_map_2.tscn")
		_:
			Transition.change_scene("res://Menu/Level_map_1.tscn")

func _on_Player_pressed():
	get_tree().paused = false
	Transition.change_scene("res://PlayerHolder/Player_customize.tscn")


func _on_restart_pressed():
	get_tree().paused = false
	GlobalScript.restart = true
	get_tree().reload_current_scene()
