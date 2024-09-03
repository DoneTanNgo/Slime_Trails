extends Node2D
var work = true
var second_phase = false
func _ready():
	Stats.ammo = 10
	Stats.current_Hp = Stats.max_Hp
	Stats.last_lvl = "res://Levels/Level3.tscn"
	$Timer.x_range_min = -1500
	$Timer.x_range_max = 2600
	$Timer.y_range_min = -450
	$Timer.y_range_max = 1882
	$Timer2.x_range_min = -1500
	$Timer2.x_range_max = 2600
	$Timer2.y_range_min = -450
	$Timer2.y_range_max = 1882
	$Player/Light2D.visible = false
	$Player/Camera2D.current = false
	$Player/Camera2D.visible = false
	pass
	
func _process(delta):
	if(EnemeyStats.current_Hp<=EnemeyStats.max_Hp/2&&!second_phase&&!$Enemey.during_attack):
		second_phase = true
#		$PlayField2.position = Vector2(-21,62)
#		$PlayField.position = Vector2(10000,10000)
		$Enemey.disabled = true
		$Player.disabled = true
		
		$Player.position = Vector2(452,1063)
		$Player/Camera2D2.position = Vector2(1,-1259)
		$Enemey/Arms.play("half_phase")
		yield($Enemey/Arms,"animation_finished")
		$Enemey/Arms.play("rest")
		$AnimationPlayer.play("crumble_arena")
		yield($AnimationPlayer,"animation_finished")
		$Player/Camera2D2.position = Vector2(1,-7)
		$Player/CollisionShape2D.disabled = false
		$Player.disabled = false
		$Enemey.disabled = false
	if(EnemeyStats.current_Hp<=0&&work):
		work = !work
		Stats.dragon_finished = true
		GlobalScript._saving()
		$Player/Area2D/CollisionShape2D2.disabled = true
		$Player.moving = false
		$Player.can_shoot = false
		$Enemey/Head.play("Death")
		yield($Enemey/Head,"animation_finished")
		
		$Player.emit_signal("win")
		$Player.position = Vector2(800,850)
