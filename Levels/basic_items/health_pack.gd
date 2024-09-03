extends Node2D
func _ready():
	$Timer.start()
	$AnimationPlayer.play("LifeSpan")
	
func _on_Area2D_area_entered(area):
	if(area.is_in_group("player_group")):
		if(Stats.current_Hp+5 < Stats.max_Hp):
			Stats.current_Hp += 5
			self.queue_free()
		else:
			Stats.current_Hp = Stats.max_Hp
			self.queue_free()


func _on_Timer_timeout():
	queue_free()
