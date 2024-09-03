extends Node2D

func _ready():
	$CanvasModulate.color = Color(0,0,0,10)
	$Player.platforming = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
