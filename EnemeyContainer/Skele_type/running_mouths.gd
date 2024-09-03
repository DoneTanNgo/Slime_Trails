extends KinematicBody2D
onready var words = load("res://EnemeyContainer/bullets/words_bullet.tscn")
var max_hp = 20
var cur_hp = 20
var run_speed = 800
var velocity = Vector2.ZERO
var direction = Vector2(1,1)
var player = null
var time = 0.0
var died = false
var walking = true
func _ready():
	died = true
	$AnimationPlayer.play("spawn")
	yield(get_tree().create_timer(0.9),"timeout")
	died = false
	$AnimationPlayer.play("running")



func _physics_process(delta):
	if(!died&&walking):
		$AnimationPlayer.play("running")
		run_speed = 1000
		velocity = Vector2.ZERO
		var x = 1
		if(rand_range(-1,1)>0):
			x = 1
		else:
			x = -1
		if(direction.x>0):
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true
		if(is_on_wall()):
			direction.y = -(direction.y)
			direction.x = -x*(direction.x)
		print(direction)
		velocity = direction * run_speed
		velocity = move_and_slide(velocity)

func _shoot():
	$AnimationPlayer.play("shoot")
	var player = get_tree().get_nodes_in_group("player_group")[0]
	walking = false
	var b = words.instance()
	add_child(b)
	b._change_frame(rand_range(0,27))
	b.global_transform = $Position2D.global_transform
	yield($AnimationPlayer,"animation_finished")
	walking = true

func onHit(damage) -> void:
	cur_hp -= damage
	if(cur_hp<=0):
		died = true
		$AnimationPlayer.play("death")
		yield($AnimationPlayer,"animation_finished")
		queue_free()

func _on_Area2D_area_entered(area):
	if(area.is_in_group("player_group")):
		Stats.emit_signal("dectect_damage",5)


func _on_Timer_timeout():
	$Timer.start(3)
	_shoot()
