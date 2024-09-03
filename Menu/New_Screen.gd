extends Control
var new_name
var saving
var mage_finish = false
var knight_finish = false
var dragon_finish = false
var falling_finish = false
var skeleton_finish = false
var final_finish = false

signal textbox_closed

func _ready():
	$"HBoxContainer/Load 1".grab_focus()
	$VideoPlayer.visible = false
	saving = null
	new_name = null
	var file = File.new()
	var dir = Directory.new()
	if !dir.dir_exists("user://Saves/Data1.dat"):
		dir.make_dir_recursive("user://Saves/Save_Data1.dat")
	if(!file.file_exists("user://Saves/Data1.dat")):
		file.open("user://Saves/Data1.dat",File.WRITE)
		file.close()
	
	if !dir.dir_exists("user://Saves/Save_Data2.dat"):
		dir.make_dir_recursive("user://Saves/Save_Data2.dat")
		print("working")
	if(!file.file_exists("user://Saves/Data2.dat")):
		file.open("user://Saves/Data2.dat",File.WRITE)
		file.close()
		
	if !dir.dir_exists("user://Saves/Save_Data3.dat"):
		dir.make_dir_recursive("user://Saves/Save_Data3.dat")
	if(!file.file_exists("user://Saves/Data3.dat")):
		file.open("user://Saves/Data3.dat",File.WRITE)
		file.close()
	
	
		
	
	if(file.file_exists("user://Saves/Data1.dat")):
		var error = file.open("user://Saves/Data1.dat", File.READ)
		if error == OK:	
			if(file.get_len()>0):
				var player_data = file.get_var()
				if(player_data):
					Stats.file = "user://Saves/Data1.dat"
					read_file(player_data)
					var current_boss = "mage"
					if(!Stats.mage_finished):
						current_boss = "Mage"
					elif(!Stats.knight_finished):
						current_boss = "Knight"
					elif(!Stats.dragon_finished):
						current_boss = "Dragon"
					elif(!Stats.falling_finished):
						current_boss = "Falling"
					elif(!Stats.skeleton_finished):
						current_boss ="Skeleton"
					elif(!Stats.final_boss_finished):
						current_boss = "???"
					else:
						current_boss = "Lmao Couldn't find it"
					var temp = Stats.player_name
					$"HBoxContainer/Load 1/Label".text = "Name:\n%s\nCurrent Boss:\n%s" % [temp,current_boss]
				
	if(file.file_exists("user://Saves/Data2.dat")):
		var error = file.open("user://Saves/Data2.dat", File.READ)
		if error == OK:
			if(file.get_len()>0):
				var player_data = file.get_var()
				if(player_data):
					Stats.file = "user://Saves/Data2.dat"
					read_file(player_data)
					var current_boss = "mage"
					if(!Stats.mage_finished):
						current_boss = "Mage"
					elif(!Stats.knight_finished):
						current_boss = "Knight"
					elif(!Stats.dragon_finished):
						current_boss = "Dragon"
					elif(!Stats.falling_finished):
						current_boss = "Falling"
					elif(!Stats.skeleton_finished):
						current_boss ="Skeleton"
					elif(!Stats.final_boss_finished):
						current_boss = "???"
					else:
						current_boss = "Lmao Couldn't find it"
					var temp = Stats.player_name
					$"HBoxContainer/Load 2/Label".text = "Name:\n%s\nCurrent Boss:\n%s" % [temp,current_boss]
	if(file.file_exists("user://Saves/Data3.dat")):
		var error = file.open("user://Saves/Data3.dat", File.READ)
		if error == OK:	
			if(file.get_len()>0):
				var player_data = file.get_var()
				if(player_data):
					Stats.file = "user://Saves/Data3.dat"
					read_file(player_data)
					var current_boss = "mage"
					if(!Stats.mage_finished):
						current_boss = "Mage"
					elif(!Stats.knight_finished):
						current_boss = "Knight"
					elif(!Stats.dragon_finished):
						current_boss = "Dragon"
					elif(!Stats.falling_finished):
						current_boss = "Falling"
					elif(!Stats.skeleton_finished):
						current_boss ="Skeleton"
					elif(!Stats.final_boss_finished):
						current_boss = "???"
					else:
						current_boss = "Lmao Couldn't find it"
					var temp = Stats.player_name
					$"HBoxContainer/Load 3/Label".text = "Name:\n%s\nCurrent Boss:\n%s" % [temp,current_boss]

func _on_Load_1_pressed():
	var file = File.new()
	if(file.file_exists("user://Saves/Data1.dat")):
		var error = file.open("user://Saves/Data1.dat", File.READ)
		if error == OK:
			if(file.get_len()>0):
				var player_data = file.get_var()
				if(player_data):
					display_text(1,"Do You Want to erase this current save file")
					yield(self,"textbox_closed")
					if(saving):
						Stats.file = "user://Saves/Data1.dat"
						make_new("user://Saves/Data1.dat")
						yield($Popup/LineEdit,"text_entered")
			else:
				make_new("user://Saves/Data1.dat")
#	$Popup.visible = true
#	$Popup/LineEdit.grab_focus()
#	yield($Popup/LineEdit,"text_entered")
#	$Popup.visible = false
#	var data = {
#	"name" : new_name,
#	"lvl" : 0,
#	"boss_completed" : 0,
#	"mage_finished" : false,
#	"mage_hard_finished" : false,
#	"knight_finished" : false,
#	"knight_hard_finished" : false,
#	"dragon_finished" : false,
#	"dragon_hard_finished" : false,
#	"weapon_one" : 0,
#	"weapon_two" : 1
#	}
#	file.open("user://Saves/Data1.dat", File.WRITE)
#	file.store_var(data)
#	file.close()


func _on_Load_2_pressed():
	var file = File.new()
	if(file.file_exists("user://Saves/Data2.dat")):
		var error = file.open("user://Saves/Data2.dat", File.READ)
		if error == OK:
			if(file.get_len()>0):
				var player_data = file.get_var()
				if(player_data):
					display_text(1,"Do You Want to erase this current save file")
					yield(self,"textbox_closed")
					if(saving):
						Stats.file = "user://Saves/Data2.dat"
						make_new("user://Saves/Data2.dat")
						yield($Popup/LineEdit,"text_entered")
			else:
				make_new("user://Saves/Data2.dat")

func _on_Load_3_pressed():
	var file = File.new()
	if(file.file_exists("user://Saves/Data3.dat")):
		var error = file.open("user://Saves/Data3.dat", File.READ)
		if error == OK:
			if(file.get_len()>0):
				var player_data = file.get_var()
				if(player_data):
					display_text(1,"Do You Want to erase this current save file")
					yield(self,"textbox_closed")
					if(saving):
						Stats.file = "user://Saves/Data3.dat"
						make_new("user://Saves/Data3.dat")
						yield($Popup/LineEdit,"text_entered")
			else:
				make_new("user://Saves/Data3.dat")
	
func _on_Back_To_Menu_pressed():
	get_tree().change_scene("res://Menu/Menu.tscn")
	


func make_new(save_dir)-> void:
	var file = File.new()
	$Popup.visible = true
	$Popup/LineEdit.grab_focus()
	yield($Popup/LineEdit,"text_entered")
	$Popup.visible = false
	var data = {
	"name" : new_name,
	"mage_finished" : false,
	"knight_finished" : false,
	"dragon_finished" : false,
	"falling_finished" : false,
	"skeleton_finished" : false,
	"final_boss_finished" : false,
	"map_slime_position" : Vector2(13,760),
	"map_slime_location" : 0,
	"weapon_one" : 0,
	"weapon_two" : 1
	}
	Stats.player_name = new_name
	Stats.mage_finished = false
	Stats.knight_finished = false
	Stats.dragon_finished = false
	Stats.falling_finished = false
	Stats.skeleton_finished = false
	Stats.map_slime_position = Vector2(13,760)
	Stats.map_slime_location = 0
	Stats.proj_1 = 0
	Stats.proj_2 = 1
	file.open(save_dir, File.WRITE)
	file.store_var(data)
	file.close()
	$VideoPlayer.visible = true
	$VideoPlayer.play()
	yield($VideoPlayer,"finished")
	Transition.change_scene("res://Levels/Tutorials.tscn")

func _input(event):
	if(Input.is_action_just_pressed("Left_Click") or Input.is_mouse_button_pressed(BUTTON_LEFT)) and $WindowDialog/Label.visible and $WindowDialog/Yes.visible==false:
		$WindowDialog.hide()
		emit_signal("textbox_closed")
		
func display_text(erase,text) -> void:
	if(erase==0):
		$WindowDialog.show()
		$WindowDialog/No.hide()
		$WindowDialog/Yes.hide()
		yield(self,"textbox_closed")
	else:
		$WindowDialog.show()
		$WindowDialog/No.visible = true
		$WindowDialog/Yes.visible = true
		$WindowDialog/Yes.grab_click_focus()
		yield(self,"textbox_closed")
		pass

func read_file(lib) -> void:
	if(lib.name):
		Stats.player_name = lib.name
	else:
		Stats.player_name = "Slime_boi"
	if(lib.mage_finished):
		Stats.mage_finished = lib.mage_finished
	else:
		Stats.mage_finished = false
	if(lib.knight_finished):
		Stats.knight_finished = lib.knight_finished
	else:
		Stats.knight_finished = false
	if(lib.dragon_finished):
		Stats.dragon_finished = lib.dragon_finished
	else:
		Stats.dragon_finished = false
	if(lib.falling_finished):
		Stats.falling_finished = lib.falling_finished
	else:
		Stats.falling_finished = false
	if(lib.skeleton_finished):
		Stats.skeleton_finished = lib.skeleton_finished
	else:
		Stats.skeleton_finished = false
	if(lib.final_boss_finished):
		Stats.final_boss_finished = lib.final_boss_finished
	else:
		Stats.final_boss_finished = false
	if(lib.map_slime_position):
		Stats.map_slime_position = lib.map_slime_position
	else:
		Stats.map_slime_location = Vector2(0,0)
	if(lib.map_slime_location):
		Stats.map_slime_location = lib.map_slime_location
	else:
		Stats.map_slime_location = 0
	if(lib.weapon_one):
		Stats.proj_1 = lib.weapon_one
	else:
		Stats.proj_1 = 0
	if(lib.weapon_two):
		Stats.proj_2 = lib.weapon_two
	else:
		Stats.proj_2 = 1

func _on_Yes_pressed():
	saving = true
	$WindowDialog.hide()
	emit_signal("textbox_closed")


func _on_No_pressed():
	saving = false
	$WindowDialog.hide()
	emit_signal("textbox_closed")


func _on_LineEdit_text_entered(new_text):
	new_name = new_text


func _on_cancel_pressed():
	$Popup.hide()


func _on_quick_play_pressed():
	$quick_play/Popup.show()
	$quick_play/Popup/Panel/VBoxContainer/mage_finish.pressed = mage_finish
	$quick_play/Popup/Panel/VBoxContainer/knight_finish.pressed = knight_finish
	$quick_play/Popup/Panel/VBoxContainer/dragon_finish.pressed = dragon_finish
	$quick_play/Popup/Panel/VBoxContainer/falling_finish.pressed = falling_finish
	$quick_play/Popup/Panel/VBoxContainer/skeleton_finish.pressed = skeleton_finish
	$quick_play/Popup/Panel/VBoxContainer/final_finish.pressed = final_finish
	yield(self,"textbox_closed")

func _quick_player():
	Stats.player_name = new_name
	Stats.mage_finished = mage_finish
	Stats.knight_finished = knight_finish
	Stats.dragon_finished = dragon_finish
	Stats.falling_finished = falling_finish
	Stats.skeleton_finished = skeleton_finish
	Stats.final_boss_finished = final_finish
	Stats.map_slime_position = Vector2(13,760)
	Stats.map_slime_location = 0
	Stats.proj_1 = 0
	Stats.proj_2 = 1
	Stats.file = ""
	$VideoPlayer.visible = true
	$VideoPlayer.play()
	yield($VideoPlayer,"finished")
	Transition.change_scene("res://Levels/Tutorials.tscn")


func _on_mage_finish_pressed():
	mage_finish = !mage_finish


func _on_knight_finish_pressed():
	knight_finish = !knight_finish


func _on_falling_finish_pressed():
	falling_finish = !falling_finish


func _on_dragon_finish_pressed():
	dragon_finish = !dragon_finish


func _on_skeleton_finish_pressed():
	skeleton_finish = !skeleton_finish


func _on_final_finish_pressed():
	final_finish = !final_finish


func _on_out_pressed():
	$quick_play/Popup.hide()
	emit_signal("textbox_closed")


func _on_enter_pressed():
	$quick_play/Popup.hide()
	emit_signal("textbox_closed")
	_quick_player()
