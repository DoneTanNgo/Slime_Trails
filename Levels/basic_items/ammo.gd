extends Node2D
func _ready():
	$Timer.start()
	$AnimationPlayer.play("LifeSpan")
	
func _on_Area2D_area_entered(area):
	if(area.is_in_group("player_group")):
		Stats.ammo += 15
		self.queue_free()


func _on_Timer_timeout():
	queue_free()
