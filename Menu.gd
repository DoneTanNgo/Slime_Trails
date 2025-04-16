extends Control

func _ready():
	var music = MusicPlayer.get_stream()
	$VBoxContainer/Load.grab_focus()
	if(music != str("res://Sound/Menu.mp3")):
		MusicPlayer.play_music("res://Sound/Menu.mp3")

func _on_Load_pressed():
	Transition.change_scene("res://Menu/Load_Screen.tscn")

func _on_New_pressed():
	Transition.change_scene("res://Menu/New_screen.tscn")

func _on_Setting_pressed():
	Transition.change_scene("res://Menu/Setting.tscn")

func _on_Exit_pressed():
	get_tree().quit()
