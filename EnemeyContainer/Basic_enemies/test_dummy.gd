extends KinematicBody2D

func onHit(damage) -> void:
	$AnimationPlayer.play("damaged")
	print(damage)

