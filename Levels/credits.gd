extends Node2D
var start = false
var level 
var into = 0
func _ready():
	
	$VideoPlayer.play()

func _process(delta):
	if(start):
		$text_label.global_position = $text_label.global_position - Vector2(0.65,0)
	if(int($text_label.global_position.x) == -6900):
		level = preload("res://Menu/Menu.tscn")
		Transition.change_scene_to(level)
	match into:
		1:
			$mage.position = lerp($mage.position,$mage_pos.position,0.005)
		2:
			$knight.position =lerp($knight.position,$knight_pos.position,0.005)
		3:
			$dragon.position = lerp($dragon.position,$dragon_pos.position,0.005)
		4:
			$skeleton.position = lerp($skeleton.position,$skeleton_pos.position,0.005)
		_:
			pass
		

func _intro_char(x):
	match x:
		1:
			$mage.position = $mage.position.lerp($mage_pos,0.4)
		2:
			$knight.position = $knight.position.lerp($knight_pos,0.4)
		3:
			$dragon.position = $dragon.position.lerp($dragon_pos,0.4)
		4:
			$skeleton.position = $skeleton.position.lerp($skeleton_pos,0.4)
		_:
			pass
	pass

func _on_VideoPlayer_finished():
	var music = MusicPlayer.get_stream()
	if(music != str("res://Sound/mus_Credits.mp3")):
		MusicPlayer.play_music("res://Sound/mus_Credits.mp3")
	$VideoPlayer.visible = false
	$intro.start()
	$Timer.start()
	start = true
	$Creditsland/AnimationPlayer.play("loop")
	$AnimationPlayer.play("walk")

func _on_Timer_timeout():
	$Sprite.visible = true
	$Sprite/transition_player.play("fadein_out")


func _on_intro_timeout():
	into += 1
	$intro.start(30)
