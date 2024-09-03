extends Node2D
var finger_bullet = load("res://EnemeyContainer/bullets/placeholder_bullets.tscn")
onready var head = get_node("head")
onready var left_hand = get_node("left_hand")
onready var right_hand = get_node("right_hand")
var head_cur_hp = 300.0
var head_max_hp = 300.0
var right_cur_hp = 200.0
var left_cur_hp = 200.0
var timer = 0.0
const TIMER_TIME = 3
var rng
var ani_spawn = true
var timer_active = false
var allow_timer = true
var can_hit = true
var switch = true
var animation_timer = false
var phase = 0
func _ready():
	left_hand.stop = true
	right_hand.stop = true
	left_cur_hp = left_hand.cur_hp
	right_cur_hp = right_hand.cur_hp
	head_cur_hp = head.cur_hp
	EnemeyStats.skele_left_down = false
	EnemeyStats.skele_right_down = false
	EnemeyStats.current_Hp = head_cur_hp
	EnemeyStats.max_Hp = head_cur_hp


func _process(delta):
	left_cur_hp = left_hand.cur_hp
	right_cur_hp = right_hand.cur_hp
	head_cur_hp = head.cur_hp
	EnemeyStats.current_Hp = head_cur_hp
	if(head_cur_hp<head.max_hp/2&&phase==0):
		phase += 1
		_check_phase(phase)
	if(left_cur_hp<left_hand.max_hp/2||right_cur_hp<right_hand.max_hp/2&&phase==1):
		phase += 1
		_check_phase(phase)

func _check_phase(phase):
	print("something phasing")
	match phase:
		1:
			print("phase 1")
			left_hand.stop = false
			right_hand.stop = false
			head.stop = true
			$head/CollisionShape2D.disabled = true
			head.walking = false
			$head/ani_head.play("half_time")
		2:
			head.walking = true
			head.stop = false
			$head/ani_head.play_backwards("half_time")
			$head/CollisionShape2D.disabled = false
	pass

func _side_hands_shot():
	var v = Vector2.ZERO
	while(left_hand.global_position>=$left_arm_orginal_pos.global_position&&right_hand.global_position<=$right_arm_orginal_pos.global_position):
		right_hand.walking = false
		right_hand.can_hit = false
		left_hand.can_hit = false
		left_hand.walking = false
		yield(get_tree(),"idle_frame")
		v = right_hand.global_position.direction_to($right_arm_orginal_pos.global_position)  * 250
		v = right_hand.move_and_slide(v)
		v = left_hand.global_position.direction_to($left_arm_orginal_pos.global_position) * 250
		v = left_hand.move_and_slide(v)
	left_hand.left_gun_out(3,0.5)
	right_hand.right_gun_out(3,0.5)


func start_timer() -> void:
	timer = TIMER_TIME
	timer_active = true

func _on_ani_spawn_timer_timeout():
	ani_spawn = false
	$ani_spawn/ani_spawn_timer.stop()

func _on_gen_timer_timeout():
	animation_timer = false
	$gen_timer.stop()



