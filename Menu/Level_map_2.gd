extends Node2D
var level
var slevel = ""
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var music = MusicPlayer.get_stream()
	if(music != str("res://Sound/tutorial song (1).mp3")):
		MusicPlayer.play_music("res://Sound/tutorial song (1).mp3")
	$Map_Slime.position = Stats.map_slime_position
	Stats.from_map = true
	Stats.last_lvl = "res://Menu/Level_map_2.tscn"
	Stats.map_slime_location = 1
	if(Stats.skeleton_finished):
		$wtfmonster.visible = false
		$WTF/CollisionShape2D.disabled = false
	else:
		$wtfmonster.color = Color("263238")
		$WTF/CollisionShape2D.disabled = true

func _process(delta):
	if(level && Input.is_action_just_pressed("interact")):
		GlobalScript._saving()
		Stats.map_slime_position = $Map_Slime.position
		if(slevel=="res://Menu/Level_map_1.tscn"):
			Stats.map_slime_position = Vector2(131.6, -606.8)
		Transition.change_scene_to(level)

func _enter_area(name):
	$Map_Slime/popup.visible = true
	$Map_Slime/popup/name.text = name
func _exit_area():
	$Map_Slime/popup.visible = false
	level = null
	
func _on_Exit_level_area_entered(area):
	if(area.is_in_group("player_group")):
		_enter_area("Back to Wrld 1")
		level = load("res://Menu/Level_map_1.tscn")
		slevel = "res://Menu/Level_map_1.tscn"


func _on_Exit_level_area_exited(area):
	if(area.is_in_group("player_group")):
		_exit_area()


func _on_Tutorial_area_entered(area):
	if(area.is_in_group("player_group")):
		_enter_area("Tutorial_2")
		level = "res://Levels/Tutorial_wrld_2.tscn"


func _on_Tutorial_area_exited(area):
	if(area.is_in_group("player_group")):
		_exit_area()


func _on_Skeleton_area_area_entered(area):
	if(area.is_in_group("player_group")):
		_enter_area("Skeleton")
		level = preload("res://Levels/Level5.tscn")
		slevel = "res://Levels/Level5.tscn"


func _on_Skeleton_area_area_exited(area):
	if(area.is_in_group("player_group")):
		_exit_area()


func _on_WTF_area_entered(area):
	if(area.is_in_group("player_group")):
		_enter_area("Final Boss")
		level = preload("res://Levels/Level6.tscn")
		slevel = "res://Levels/Level6.tscn"


func _on_WTF_area_exited(area):
	if(area.is_in_group("player_group")):
		_exit_area()

func _on_TextureButton_pressed():
	Stats.map_slime_position = $Map_Slime.position
	Transition.change_scene("res://PlayerHolder/Player_customize.tscn")
