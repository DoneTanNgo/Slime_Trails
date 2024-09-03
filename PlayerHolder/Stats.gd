extends Node
export var player_name = ""
export var file = ""
export var mage_finished = false
export var knight_finished = false
export var dragon_finished = false
export var falling_finished = false
export var skeleton_finished = false
export var final_boss_finished = false
export var dodge_stat = 0
export var max_Hp = 50
export var current_Hp = 50
export var ammo = 10.0
export var proj_1 = 0
export var proj_2 = 6
export var swaped = false
export var is_dodging = false
export var dodging = 5
export var map_slime_position = Vector2(0,0)
export var map_slime_location = 0
export var from_map = false
export var last_lvl = "res://Menu/Menu.tscn"
export var demo = false
export var sfx_on = true
signal dectect_damage(dmg)

func _ready():
	connect("dectect_damage",self,"_dectect_damage")
	max_Hp = current_Hp

func dodge_timer() -> bool:
	return true

func _dectect_damage(damage):
	current_Hp = current_Hp - damage
#	print(current_Hp)
#	if(current_Hp<=0):
#		var p = get_tree().get_nodes_in_group("player_group")[0]

func _death()->void:
	pass

func projectile_find(x) -> Array:
	#Array["Method",damage,cooldown,ammo]
	match x:
		0:
			return ["pistol_shot",4,0.4,1,0]#Damage: 4 Cooldown: 0.4, 1
		1:
			return ["shotgun_shot",4,0.5,3,1]
		2:
			return ["bubble_shot",1,0.2,1,2]
		3:
			return ["melee_shot",6,0.5,0,3]
		4:
			return ["charge_shot",2,0.5,2,4]
		5:
			return ["boomrang_shot",2,0.5,1,5]
		6:
			return ["muck_shot",6,0.3,1,6]
		_:
			return [null]

