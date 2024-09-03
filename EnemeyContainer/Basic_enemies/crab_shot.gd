extends KinematicBody2D

var bullet_scene = load("res://EnemeyContainer/bullets/placeholder_bullets.tscn")
var max_hp = 20
var cur_hp = 20
var run_speed = 250
var velocity = Vector2.ZERO
var player = null
var can_shot = true

func _physics_process(delta):
	velocity = Vector2.ZERO
	while(player&&can_shot):
		shot()
		#
		
func shot() -> void:
	if(can_shot):
		can_shot = false
		var y = Timer.new()
		y.set_wait_time(1)
		add_child(y)
		y.start()
		yield(y,"timeout")
		if(player):
			$Position2D.look_at(Vector2(player.position))
			var b = bullet_scene.instance()
			add_child(b)
			b.transform = $Position2D.global_transform
		can_shot = true

func _on_Area2D_body_entered(body):
	if(body.is_in_group("player_group")):
		player = body
		print(player.position)
		print(position)


func _on_Area2D_body_exited(body):
	if(body.is_in_group("player_group")):
		player = null
		
func onHit(damage) -> void:
	cur_hp -= damage
	if(cur_hp<=0):
		queue_free()
	pass
