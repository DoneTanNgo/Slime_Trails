extends Control


func _ready():
	var music = MusicPlayer.get_stream()
	if(music != str("res://Sound/Menu.mp3")):
		MusicPlayer.play_music("res://Sound/Menu.mp3")
		
	Stats.last_lvl = "res://Menu/Level_select.tscn"
	if(Stats.mage_finished):
		$Knight.text = "Knight"
		$Knight.disabled = false
	else:
		$Knight.text = "???"
		$Knight.disabled = true
	if(Stats.knight_finished):
		$Dragon.text = "Dragon"
		$Dragon.disabled = false
	else:
		$Dragon.text = "???"
		$Dragon.disabled = true
	if(Stats.dragon_finished):
		$Transition.text = "Falling"
		$Transition.disabled = false
	else:
		$Transition.text = "???"
		$Transition.disabled = true
	if(Stats.falling_finished):
		$Skeleton.text = "Skeleton"
		$Skeleton.disabled = false
	else:
		$Skeleton.text = "???"
		$Skeleton.disabled = true
	if(Stats.skeleton_finished):
		$BatRat.text = "BatRat"
		$BatRat.disabled = false
	else:
		$BatRat.text = "???"
		$BatRat.disabled = true


func _on_Back_To_Menu_pressed():
	Transition.change_scene("res://Menu/In_Menu.tscn")

func _on_Mage_pressed():
	Transition.change_scene("res://Levels/Level1.tscn")

func _on_Knight_pressed():
	Transition.change_scene("res://Levels/Level2.tscn")

func _on_Dragon_pressed():
	Transition.change_scene("res://Levels/Level3.tscn")

func _on_Player_pressed():
	Transition.change_scene("res://PlayerHolder/Player_customize.tscn")

func _on_Transition_pressed():
	Transition.change_scene(("res://Levels/Level4.tscn"))


func _on_Skeleton_pressed():
	Transition.change_scene(("res://Levels/Level5.tscn"))


func _on_BatRat_pressed():
	pass # Replace with function body.


func _on_KDJFKDS_pressed():
	pass # Replace with function body.
