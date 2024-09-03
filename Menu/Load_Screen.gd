extends Control
var new_name
var removing
signal textbox_closed
var level = preload("res://main.tscn")

func _ready():
#	var data = {
#		"name" : "",
#		"lvl" : 0,
#		"boss_completed" : 0,
#		"mage_finished" : false,
#		"mage_hard_finished" : false,
#		"knight_finished" : false,
#		"knight_hard_finished" : false,
#		"dragon_finished" : false,
#		"dragon_hard_finished" : false,
#		"weapon_one" : 0,
#		"weapon_two" : 1
#	}
	level = preload("res://main.tscn")
	$"HBoxContainer/Load 1".grab_focus()
	var dir = Directory.new()
	var file = File.new()
	if !dir.dir_exists("user://Saves/Save_Data1.dat"):
		dir.make_dir_recursive("user://Saves/Save_Data1.dat")
	if(!file.file_exists("user://Saves/Data1.dat")):
		file.open("user://Saves/Data1.dat",File.WRITE)
		file.close()
	
	if !dir.dir_exists("user://Saves/Save_Data2.dat"):
		dir.make_dir_recursive("user://Saves/Save_Data2.dat")
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
	

	print("Saved")

func _on_Load_1_pressed():
	level = preload("res://Menu/In_Menu.tscn")
	var file = File.new()
	if(file.file_exists("user://Saves/Data1.dat")):
		var error = file.open("user://Saves/Data1.dat", File.READ)
		if error == OK:	
			if(file.get_len()>0):
				var player_data = file.get_var()
				if(player_data):
					Stats.file = "user://Saves/Data1.dat"
					read_file(player_data)
					$Panel/Sprite.visible = true
					
					Transition.change_scene_to(level)
			else:
				display_text(0,"Can't Find Save File")
	file.close()


func _on_Load_2_pressed():
	level = preload("res://Menu/In_Menu.tscn")
	var file = File.new()
	if(file.file_exists("user://Saves/Data2.dat")):
		var error = file.open("user://Saves/Data2.dat", File.READ)
		if error == OK:
			if(file.get_len()>0):
				var player_data = file.get_var()
				if(player_data):
					Stats.file = "user://Saves/Data2.dat"
					read_file(player_data)
					$Panel/Sprite.visible = true
					Transition.change_scene_to(level)
			else:
				display_text(0,"Can't Find Save File")
		else:
			print("error")
	file.close()

func _on_Load_3_pressed():
	level = preload("res://Menu/In_Menu.tscn")
	var file = File.new()
	if(file.file_exists("user://Saves/Data3.dat")):
		var error = file.open("user://Saves/Data3.dat", File.READ)
		if error == OK:
			if(file.get_len()>0):
				var player_data = file.get_var()
				if(player_data):
					Stats.file = "user://Saves/Data3.dat"
					read_file(player_data)
					$Panel/Sprite.visible = true
					Transition.change_scene_to(level)
			else:
				display_text(0,"Can't Find Save File")
		else:
			print("error")
	file.close()
	
func read_file(lib) -> void:
	Stats.player_name = lib.name
	Stats.mage_finished = lib.mage_finished
	Stats.knight_finished = lib.knight_finished
	Stats.dragon_finished = lib.dragon_finished
	Stats.falling_finished = lib.falling_finished
	Stats.skeleton_finished = lib.skeleton_finished
	Stats.final_boss_finished = lib.final_boss_finished
	Stats.map_slime_position = lib.map_slime_position
	Stats.map_slime_location = lib.map_slime_location
	Stats.proj_1 = lib.weapon_one
	Stats.proj_2 = lib.weapon_two
	

	
func _input(event):
	if(Input.is_action_just_pressed("Left_Click") or Input.is_mouse_button_pressed(BUTTON_LEFT)) and $WindowDialog/Label.visible && !$WindowDialog/Yes.visible:
		$WindowDialog.hide()
		emit_signal("textbox_closed")
		
func display_text(erase,text) -> void:
	$"HBoxContainer/Load 1".disabled = true
	$"HBoxContainer/Load 2".disabled = true
	$"HBoxContainer/Load 3".disabled = true
	$WindowDialog/Label.text = text
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
	$"HBoxContainer/Load 1".disabled = false
	$"HBoxContainer/Load 2".disabled = false
	$"HBoxContainer/Load 3".disabled = false

	
func _on_Back_To_Menu_pressed():
	Transition.change_scene("res://Menu/Menu.tscn")


func _on_LineEdit_text_entered(new_text):
	new_name = new_text



func _on_Delete_pressed():
	var dir = Directory.new()
	var file = File.new()
	if(file.file_exists("user://Saves/Data1.dat")):
		file.open("user://Saves/Data1.dat",File.READ)
		if(file.get_len()>0):
			display_text(1,"You sure you want to do this")
			yield(self,"textbox_closed")
			if(removing):
				dir.remove("user://Saves/Data1.dat")
				file.open("user://Saves/Data1.dat",File.WRITE)
				$"HBoxContainer/Load 1/Label".text = "Name:\n\nCurrent Boss:\n"
	file.close()


func _on_Delete2_pressed():
	var dir = Directory.new()
	var file = File.new()
	if(file.file_exists("user://Saves/Data2.dat")):
		file.open("user://Saves/Data2.dat",File.READ)
		if(file.get_len()>0):
			display_text(1,"You sure you want to do this")
			yield(self,"textbox_closed")
			if(removing):
				dir.remove("user://Saves/Data2.dat")
				file.open("user://Saves/Data2.dat",File.WRITE)
				$"HBoxContainer/Load 2/Label".text = "Name:\n\nCurrent Boss:\n"
	file.close()

func _on_Delete3_pressed():
	var dir = Directory.new()
	var file = File.new()
	if(file.file_exists("user://Saves/Data3.dat")):
		file.open("user://Saves/Data3.dat",File.READ)
		if(file.get_len()>0):
			display_text(1,"You sure you want to do this")
			yield(self,"textbox_closed")
			if(removing):
				dir.remove("user://Saves/Data3.dat")
				file.open("user://Saves/Data3.dat",File.WRITE)
				$"HBoxContainer/Load 3/Label".text = "Name:\n\nCurrent Boss:\n"
	file.close()

func _on_Delete_toggle_pressed():
	$"HBoxContainer/Load 1/Delete".visible = !$"HBoxContainer/Load 1/Delete".visible
	$"HBoxContainer/Load 2/Delete2".visible = !$"HBoxContainer/Load 2/Delete2".visible
	$"HBoxContainer/Load 3/Delete3".visible = !$"HBoxContainer/Load 3/Delete3".visible


func _on_Yes_pressed():
	removing = true
	$WindowDialog.hide()
	emit_signal("textbox_closed")


func _on_No_pressed():
	removing = false
	$WindowDialog.hide()
	emit_signal("textbox_closed")
