extends Node2D
var phase = 0
var key_need_press = ""
var completed = false
var window_promt = ""
var crab = load("res://EnemeyContainer/Basic_enemies/charge_knight.tscn")
var other = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$spawnpoint/Timer.x_range_max = $spawnpoint.global_position.x
	$spawnpoint/Timer.x_range_min = $spawnpoint.global_position.x
	$spawnpoint/Timer.y_range_max = $spawnpoint.global_position.y
	$spawnpoint/Timer.y_range_min = $spawnpoint.global_position.y
	_check_phase(phase)
	$Player.can_shoot = false
	$Player/Mouse.visible = false
	$Player/Label.visible = false
	$Camera2D2.current= true
	$Player/Complete_GUI/CanvasLayer2/Player_UI/Sprite.visible = false
	$Player/Complete_GUI/CanvasLayer2/Player_UI/ProjectilesUi.visible = false
	$Player/Complete_GUI/CanvasLayer2/Player_UI/Ammo.visible = false
	$Player/Complete_GUI/CanvasLayer2/Enemey_UI.visible = false

func _check_phase(phase):
	completed = false
	$CanvasLayer/WindowDialog2.visible = false
	match phase:
		0:
			$Player/Key2.hframes = 7
			$CanvasLayer/WindowDialog/Label.text = "Movement Keys"
			$Player/Key2.frame = 31
			key_need_press = "Up"
		1:
			$Player/Key2.frame = 27
			key_need_press = "Down"
		2:
			$Player/Key2.frame = 12
			key_need_press = "Right"
		3:
			$Player/Key2.frame = 9
			key_need_press = "Left"
		4:
			$Player/Key2.hframes = 5
			$CanvasLayer/WindowDialog/Label.text = "lower your speed for all movement keys"
			key_need_press = "Sprint"
			$Player/Label.visible =true
			$Player/Key2.frame = 28
		5:
			$Player/Key2.hframes = 7
			$CanvasLayer/WindowDialog/Label.text = "Shooting for attacking enemeys"
			$Player.can_shoot = true
			$Player/Label.visible = false
			key_need_press = "Left_Click"
			$Player/Key2.visible = false
			$Player/Mouse.visible = true
			$Player/Complete_GUI/CanvasLayer2/Player_UI/Sprite.visible = true
			$Player/Complete_GUI/CanvasLayer2/Player_UI/ProjectilesUi.visible = true
			$Player/Complete_GUI/CanvasLayer2/Player_UI/Ammo.visible = true
		7:
			other = true
			$CanvasLayer/dodge.visible = true
			$CanvasLayer/WindowDialog/Label.text = "HOLD the button to dodge through attacks"
			$Player/Label.visible = true
			$CanvasLayer/Key1.visible = false
			$Player/Key2.visible = false
			$Player/Mouse.flip_h = true
			key_need_press = "right_click"
		6:
			other = true
			$spawnpoint/Timer.start(3)
			$CanvasLayer/WindowDialog/Label.text = "Switching the weapons"
			$Player/Key2.visible = false
			$Player/Label.visible = false
			$CanvasLayer/Key1.visible = true
			$Player/Key2.frame = 25
			key_need_press = "Switch"
			$CanvasLayer/weapon.visible = true
		8:
			key_need_press = "interact"
			
			$CanvasLayer/WindowDialog/Label.text = "WATCH OUT DEFEAT THE ENEMIES"
			$CanvasLayer/dodge.visible = false
			$CanvasLayer/Key1.visible = false
			$Player/Key2.visible = false
			$Player/Label.visible = false
			var c = crab.instance()
			c.global_position = $spawnpoint2.global_position
			add_child(c)
			var t = crab.instance()
			t.global_position = $spawnpoint3.global_position
			add_child(t)
			_dummy_method()
		9:
			print(get_tree().get_nodes_in_group("small_group").size())
			while(get_tree().get_nodes_in_group("small_group").size()>9):
				print(get_tree().get_nodes_in_group("small_group").size())
				print("something is not working")
				var y = Timer.new()
				y.set_wait_time(1)
				add_child(y)
				y.start()
				yield(y,"timeout")
			$CanvasLayer/WindowDialog/Label.text = "NICE ONE!! NOW IT TIME FOR YOU TO SAVE YOUR FRIENDS"
			completed = true
			$CanvasLayer/WindowDialog2.visible = true
		10:
			Transition.change_scene("res://Menu/Level_map_1.tscn")
		_:
			pass

func _input(event):
	if(Input.is_action_just_pressed(key_need_press)):
		$CanvasLayer/WindowDialog2.visible = true
		completed = true
	if($CanvasLayer/weapon.visible):
		if(Input.is_action_just_pressed("space_bar")):
			$CanvasLayer/weapon.visible = false
			other = false
	if($CanvasLayer/dodge.visible):
		if(Input.is_action_just_pressed("space_bar")):
			$CanvasLayer/dodge.visible = false
			other = false
	if(completed&&!other):
		if(Input.is_action_just_pressed("space_bar")):
			phase+= 1
			_check_phase(phase)

func _dummy_method():
	phase += 1
	_check_phase(phase)
	print(phase)

func _on_ammo_on_area_entered(area):
	$Node2D/ammo_spawn.can_spawn = true


func _on_ammo_off_area_entered(area):
	$Node2D/ammo_spawn.can_spawn = false


func _on_Win_area_entered(area):
	if(area.is_in_group("player_group")):
		$Player/Area2D/CollisionShape2D2.disabled = true
		$Player.moving = false
		$Player.can_shoot = false
		$Player.emit_signal("win")


