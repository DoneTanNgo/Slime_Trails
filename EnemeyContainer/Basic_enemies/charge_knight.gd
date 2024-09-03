extends KinematicBody2D
var died = false
var max_hp = 12
var cur_hp = 12
var velocity = Vector2.ZERO
var player = null
var time = 0.0
var can_move = false
var charging = false
var charge_speed = 600
var direction = Vector2.ZERO
var last_position

func _ready():
	$AnimationPlayer.play("pop_up_mation")
	yield($AnimationPlayer,"animation_finished")
	player = get_tree().get_nodes_in_group("player_group")[0]

func _physics_process(delta):
	if(player):
		velocity = Vector2.ZERO
		if(!charging):
			charge()
		if(can_move):	
			velocity = direction * charge_speed
			velocity = move_and_slide(velocity)


func charge()-> void:
	player = get_tree().get_nodes_in_group("player_group")[0]
	$Rotation.look_at(player.position)
	charging = true
	can_move = false
	$AnimationTree.active = false
	$AnimationPlayer.play("charge_up")
	yield($AnimationPlayer,"animation_finished")
	last_position = position.direction_to(player.position)
	direction.x = (last_position.x)
	direction.y = (last_position.y)
	if(position.direction_to(player.position).x>0):
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	can_move = true
	charge_speed = 1100
	$AnimationTree.active = true
	$AnimationTree.set("parameters/charge/current",1)
	var y = Timer.new()
	y.set_wait_time(1)
	add_child(y)
	y.start()
	yield(y,"timeout")
	charging = false
	can_move = false
	pass

func onHit(damage) -> void:
	cur_hp -= damage
	if(cur_hp<=0&&!died):
		died = true
		_physics_process(false)
		
		$AnimationPlayer.play_backwards("pop_up_mation")
		yield($AnimationPlayer,"animation_finished")
		yield(charge(),"completed")	
		queue_free()
	pass

func _on_Sword_area_area_entered(area):
	if(area.is_in_group("player_group")):
		Stats.emit_signal("dectect_damage",5)
