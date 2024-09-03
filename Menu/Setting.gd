extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if(OS.vsync_enabled == true):
		$VBoxContainer/vsync.pressed = true
	if(GlobalCanvasLayer.fps_on == true):
		$VBoxContainer/fps_counter.pressed = true
	if(!Stats.sfx_on):
		$VBoxContainer/music_mute.pressed = true
	if(!MusicPlayer.allow_playing):
		$VBoxContainer/sfx_mute.pressed = true


func _on_Back_To_Menu_pressed():
	Transition.change_scene("res://Menu/Menu.tscn")


func _on_Load_1_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_CheckButton_pressed():
	OS.vsync_enabled = !OS.vsync_enabled

func _on_fps_counter_pressed():
	GlobalCanvasLayer.fps_on = !GlobalCanvasLayer.fps_on



func _on_fps_text_entered(new_text):
	if(typeof(int(new_text))==TYPE_INT):
		Engine.target_fps = int(new_text)
#
#
#func _on_sfx_text_entered(new_text):
#	if(typeof(int(new_text))==TYPE_INT):
#		if(int(new_text)>0&& int(new_text)<1):
#			Stats.volume = float(new_text/100)
#		elif(int(new_text)>1):
#			Stats.volume = 1
#		else:
#			Stats.volume = 0


func _on_sfx_mute_pressed():
	Stats.sfx_on = !Stats.sfx_on


func _on_music_mute_pressed():
	MusicPlayer.flip_playing()
