extends Node
var creature_id = "Mage"
export var current_Hp = 500
export var max_Hp = 500
export var switched = false
signal dectect_damage_enemey(dmg)
export var skele_left_option = 0
export var skele_right_option = 0
export var skele_left_down = false
export var skele_right_down = false
var bullet_scene = load("res://EnemeyContainer/bullets/mage_bullets.tscn")

func _ready():
	connect("dectect_damage_enemey",self,"_dectect_damage")

func _dectect_damage(damage):
	#if(current_Hp>=max_Hp/2):
	current_Hp = current_Hp-damage
#	else:
	#	current_Hp = current_Hp - (damage*0.75)
	if(current_Hp<0):
		var p = get_tree().get_nodes_in_group("boss_group")[0]
		p.emit_signal("dying",true)

