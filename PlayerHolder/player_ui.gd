extends Control
var weapon_stat1
var weapon_stat2

func _ready():
	$HBoxContainer/ProgressBar.value = Stats.current_Hp
	$HBoxContainer/ProgressBar.max_value = Stats.current_Hp
	weapon_stat1 = Stats.projectile_find(Stats.proj_1)
	weapon_stat2 = Stats.projectile_find(Stats.proj_2)
	pass # Replace with function body.

func _process(delta):
	$HBoxContainer/ProgressBar.value = Stats.current_Hp
	$HBoxContainer/ProgressBar.max_value = Stats.max_Hp
	$ProgressBar2.value = Stats.dodging
	if(Stats.swaped):
		$Sprite.frame = weapon_stat2[4]
		$Ammo.text = "Ammo: %d/%d" % [Stats.ammo,weapon_stat1[3]]
		$ProjectilesUi.frame = weapon_stat1[4]
	else:
		$Sprite.frame = weapon_stat1[4]
		$Ammo.text = "Ammo: %d/%d" % [Stats.ammo,weapon_stat2[3]]
		$ProjectilesUi.frame = weapon_stat2[4]

