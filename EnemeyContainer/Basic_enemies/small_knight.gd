extends KinematicBody2D
var max_hp = 50
var cur_hp = 50
var run_speed = 250
var velocity = Vector2.ZERO
var player = null
var time = 0.0
var in_area

func _ready():
	$AnimationPlayer.play("pop_up_mation")
	yield($AnimationPlayer,"animation_finished")
	player = get_tree().get_nodes_in_group("player_group")[0]

func _physics_process(delta):
	if(player):
		$Rotation.look_at(Vector2(player.position))
		$Rotation.rotation += 180
		velocity = Vector2.ZERO
		player = get_tree().get_nodes_in_group("player_group")[0]
		#print(position.direction_to(player.position))
		velocity = position.direction_to(player.position) * run_speed
		if(position.direction_to(player.position).x>0):
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
			
		while in_area:
			swipe()
			yield(get_tree().create_timer(0.2),"timeout")
			
		velocity = move_and_slide(velocity)


func swipe()-> void:
	$AnimationPlayer.play("sword_swipe")
	yield($AnimationPlayer,"animation_finished")
	pass

func onHit(damage) -> void:
	cur_hp -= damage
	if(cur_hp<=0):
		queue_free()
	pass



func _on_area_search_area_entered(area):
	if(area.is_in_group("player_group")):
		in_area = true


func _on_area_search_area_exited(area):
	if(area.is_in_group("player_group")):
		in_area = false


func _on_Sword_area_area_entered(area):
	if(area.is_in_group("player_group")):
		Stats.emit_signal("dectect_damage",5)
