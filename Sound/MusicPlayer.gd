extends Node
var menu_music = load("res://Sound/Menu.mp3")
var play
var allow_playing = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_music(music: String)-> void:
	play = music
	$MusicPlayer.stream = (load(music))
	if(allow_playing):
		$MusicPlayer.play()

func change_music()-> void:
	$MusicPlayer.stream_paused = !$MusicPlayer.stream_paused

func flip_playing():
	$MusicPlayer.playing = !$MusicPlayer.playing
	allow_playing = $MusicPlayer.playing

func get_stream() -> String:
	return play

#func change_volume(vol: float) -> void:
#	if(vol<=0):
#		$MusicPlayer.playing = false
#	elif(vol>=1):
#		$MusicPlayer.playing = true
#		$MusicPlayer.volume_db = 1
#	else:
#		$MusicPlayer.playing = true
#		$MusicPlayer.volume_db = vol
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
