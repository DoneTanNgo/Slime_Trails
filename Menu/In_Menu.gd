extends Control

func _ready():
	$Panel/TextureButton.grab_focus()
	Stats.last_lvl = "res://Menu/In_Menu.tscn"
	if(!Stats.map_slime_location||Stats.map_slime_location>1):
		Stats.map_slime_location = 0


func _on_TextureButton_pressed():
	if(Stats.map_slime_location==0):
		var level = load("res://Menu/Level_map_1.tscn")
		Transition.change_scene_to(level)
	else:
		var level = load("res://Menu/Level_map_2.tscn")
		Transition.change_scene_to(level)


func _on_Back_To_Menu_pressed():
	var level = preload("res://Menu/Menu.tscn")
	Transition.change_scene_to(level)
