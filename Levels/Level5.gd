extends Node2D
#var flip = false setget change_position
var work = true
func _ready():
#	$Top_Player/Camera2D2.current = true
	var music = MusicPlayer.get_stream()
	Stats.last_lvl = "res://Levels/Level5.tscn"
	if(music != str("res://Sound/mus_Skeleton.mp3")):
		MusicPlayer.play_music("res://Sound/mus_Skeleton.mp3")
	$Top_Player.flashlight = true
	$CanvasModulate.color = Color(0.4,0.4,0.4)
	Stats.ammo = 15
	$Timer.x_range_min = -1450
	$Timer.x_range_max = 1450
	$Timer.y_range_min = -46
	$Timer.y_range_max = 1460
	$Timer2.x_range_min = -1450
	$Timer2.x_range_max = 1450
	$Timer2.y_range_min = -46
	$Timer2.y_range_max = 1460

#func change_position(value):
#	$Top_Player/Camera2D2.current = !value
#	$Top_Player.disabled = value

#	$Plat_Player.disabled = !value
#	$Plat_zone/Plat_camera.current = value
#	print($Top_Player.disabled)
#	print($Plat_Player.disabled)
#	flip = !flip
	
#func _unhandled_input(event):
#	if event.is_action_pressed("space_bar"):
#		change_position(flip)
func _process(delta):
	if(EnemeyStats.current_Hp<=0&&work):
		$Top_Player.disabled = true
		work = !work
		Stats.skeleton_finished = true
		GlobalScript._saving()
		$Top_Player/Area2D/CollisionShape2D2.disabled = true
		$Top_Player/CollisionShape2D.disabled = true
		$Top_Player.moving = false
		$Top_Player.can_shoot = false
		
		$Skele_Top/head/ani_head.play("death")
		yield($Skele_Top/head/ani_head,"animation_finished")
		$Top_Player.emit_signal("win")
		$Top_Player.position = Vector2(800,850)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):


func _on_on_ground_area_entered(area):
	if(area.is_in_group("player_group")):
		$Top_Player.global_position = Vector2(32,733)
