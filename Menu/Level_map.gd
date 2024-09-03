extends Node2D
var level
var slevel = ""
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print(global_position)
	$Map_Slime.global_position = Stats.map_slime_position
	var music = MusicPlayer.get_stream()
	if(music != str("res://Sound/Menu.mp3")):
		MusicPlayer.play_music("res://Sound/Menu.mp3")
	Stats.from_map = true
	Stats.last_lvl = "res://Menu/Level_map_1.tscn"
	Stats.map_slime_location = 0
	if(Stats.mage_finished):
		$Knight.visible = false
		$Knight_area/CollisionShape2D.disabled = false
	else:
		$Knight.color = Color("14811c")
		$Knight_area/CollisionShape2D.disabled = true
		
	if(Stats.knight_finished):
		$Dragon.visible = false
		$Dragon_area/CollisionShape2D.disabled = false
	else:
		$Dragon.color = Color("14811c")
		$Dragon_area/CollisionShape2D.disabled = true
		
	if(Stats.dragon_finished):
		$Cave.visible = false
		$Falling_area/CollisionShape2D.disabled = false
	else:
		$Cave.color = Color("14811c")
		$Falling_area/CollisionShape2D.disabled = true
		
	if(Stats.falling_finished):
		pass
	else:
		pass
	
	$CanvasLayer/proj_1.frame = Stats.proj_1
	$CanvasLayer/proj_2.frame = Stats.proj_2
	

func _process(delta):
	if(level && Input.is_action_just_pressed("interact")):
		Stats.map_slime_position = $Map_Slime.position
		if(slevel=="res://Menu/Level_map_2.tscn"):
			Stats.map_slime_position = Vector2(26.666668, 706.451904)
		GlobalScript._saving()
		
		Transition.change_scene_to(level)

func _enter_area(name):
	$Map_Slime/popup.visible = true
	$Map_Slime/popup/name.text = name
func _exit_area():
	$Map_Slime/popup.visible = false
	level = null
	
func _on_Mage_area_area_entered(area):
	if(area.is_in_group("player_group")):
		_enter_area("mage")
		slevel = "res://Levels/Level1.tscn"
		level = preload("res://Levels/Level1.tscn")

func _on_Mage_area_area_exited(area):
	if(area.is_in_group("player_group")):
		_exit_area()

func _on_Dragon_area_area_entered(area):
	if(area.is_in_group("player_group")):
		_enter_area("dragon")
		slevel = "res://Levels/Level3.tscn"
		level = preload("res://Levels/Level3.tscn")


func _on_Dragon_area_area_exited(area):
	if(area.is_in_group("player_group")):
		_exit_area()


func _on_Knight_area_area_entered(area):
	if(area.is_in_group("player_group")):
		_enter_area("Knight")
		slevel = "res://Levels/Level2.tscn"
		level = preload("res://Levels/Level2.tscn")


func _on_Knight_area_area_exited(area):
	if(area.is_in_group("player_group")):
		_exit_area()

func _on_Exit_level_area_exited(area):
	if(area.is_in_group("player_group")):
		_exit_area()

func _on_Exit_level_area_entered(area):
	if(area.is_in_group("player_group")):
		_enter_area("To Menu")
		slevel = "res://Menu/In_Menu.tscn"
		level = preload("res://Menu/In_Menu.tscn")


func _on_Tutorial_area_entered(area):
	if(area.is_in_group("player_group")):
		_enter_area("Tutorial 1")
		slevel = "res://Levels/Tutorials.tscn"
		level = preload("res://Levels/Tutorials.tscn")


func _on_Tutorial_area_exited(area):
	if(area.is_in_group("player_group")):
		_exit_area()


func _on_Falling_area_area_entered(area):
	if(area.is_in_group("player_group")):
		_enter_area("To Cave")
		if(!Stats.falling_finished):
			slevel = "res://Levels/Level4.tscn"
			level = preload("res://Levels/Level4.tscn")
		else:
			slevel = "res://Menu/Level_map_2.tscn"
			level = preload("res://Menu/Level_map_2.tscn")


func _on_Falling_area_area_exited(area):
	if(area.is_in_group("player_group")):
		_exit_area()

func _on_TextureButton_pressed():
	Stats.map_slime_position = $Map_Slime.position
	Transition.change_scene("res://PlayerHolder/Player_customize.tscn")
