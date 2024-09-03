extends CanvasLayer
var select = 0
var equip1 = ""
var equip2 = ""
onready var flavor = get_node("Control/Flavor")
func _ready():
	_change_look(0)
	$Control/ScrollContaiiner/VBoxContainer/SingleLime.grab_focus()
	if(!Stats.mage_finished):
		$Control/ScrollContaiiner/VBoxContainer/BubbleLubble.disabled = true
		$Control/ScrollContaiiner/VBoxContainer/BubbleLubble.text = "???"
	else:
		$Control/ScrollContaiiner/VBoxContainer/BubbleLubble.disabled = false
		$Control/ScrollContaiiner/VBoxContainer/BubbleLubble.text ="Bubble Lubble"
		
	if(!Stats.knight_finished):
		$Control/ScrollContaiiner/VBoxContainer/BladeGloop.disabled = true
		$Control/ScrollContaiiner/VBoxContainer/BladeGloop.text = "???"
	else:
		$Control/ScrollContaiiner/VBoxContainer/BladeGloop.disabled = false
		$Control/ScrollContaiiner/VBoxContainer/BladeGloop.text = "Blade Gloop"
		
	if(!Stats.dragon_finished):
		$Control/ScrollContaiiner/VBoxContainer/ChargeFloop.disabled = true
		$Control/ScrollContaiiner/VBoxContainer/ChargeFloop.text = "???"
	else:
		$Control/ScrollContaiiner/VBoxContainer/ChargeFloop.disabled = false
		$Control/ScrollContaiiner/VBoxContainer/ChargeFloop.text = "Charge Snoot"
	
	if(!Stats.skeleton_finished):
		$Control/ScrollContaiiner/VBoxContainer/BoomaOoze.disabled = true
		$Control/ScrollContaiiner/VBoxContainer/BoomaOoze.text = "???"
	else:
		$Control/ScrollContaiiner/VBoxContainer/BoomaOoze.disabled = false
		$Control/ScrollContaiiner/VBoxContainer/BoomaOoze.text = "BoomaOoze"
	
	if(!Stats.final_boss_finished):
		$Control/ScrollContaiiner/VBoxContainer/muckDirect.disabled = true
		$Control/ScrollContaiiner/VBoxContainer/muckDirect.text = "???"
	else:
		$Control/ScrollContaiiner/VBoxContainer/muckDirect.disabled = false
		$Control/ScrollContaiiner/VBoxContainer/muckDirect.text = "MuckDirect"
	
	
	$Control/EquipSlot1/Currently.text = Stats.projectile_find(Stats.proj_1)[0]
	$Control/EquipSlot2/Currently.text = Stats.projectile_find(Stats.proj_2)[0]

func _on_SingleLime_pressed():
	_change_look(0)

func _on_TripleDime_pressed():
	_change_look(1)

func _on_BubbleLubble_pressed():
	_change_look(2)
	
func _on_BladeGloop_pressed():
	_change_look(3)

func _on_BoomaOoze_pressed():
	_change_look(5)

func _change_look(num: int)-> void:
	var damage = ""
	select = num
	damage = str(Stats.projectile_find(select)[2]).pad_decimals(1)
	$Control/Weapon.frame = num
	$Control/Stats.text = "Dmg: %d \n\nAmmo: %d\n\nCoolDown: %s"%[Stats.projectile_find(select)[1],Stats.projectile_find(select)[3],damage]
	if(select == 0):
		flavor.text = "A Classic Slime Staple Weapon shooting their own ... at their enemey hurting them"
	elif(select == 1):
		flavor.text = "A Customize Slime Weapon shooting 3 instead of 1 shot... Bonkers"
	elif(select == 2):
		flavor.text = "Mucus Based Slime Weapon shooting Mucus of the Slime, shooting 7 at a time"
	elif(select == 3):
		flavor.text = "A Slime Sword ... what else do you want to say Slime Sword"
	elif(select == 4):
		flavor.text = "A Charge Shot which shoots a hot ball of slime"
	elif(select == 5):
		flavor.text = "A Boomrang of Mucus, Doing more damage when returning extacly doing 10"
	elif(select == 6):
		flavor.text = "A Mucus Shot in which redirect after 1 second"
	elif(select == 7):
		pass

func _on_EquipSlot1_pressed():
	Stats.proj_1 = select
	$Control/EquipSlot1/Currently.text = Stats.projectile_find(Stats.proj_1)[0]
	
func _on_EquipSlot2_pressed():
	Stats.proj_2 = select
	$Control/EquipSlot2/Currently.text = Stats.projectile_find(Stats.proj_2)[0]


func _on_Button_pressed():
	GlobalScript._saving()
	Transition.change_scene(Stats.last_lvl)


func _on_ChargeFloop_pressed():
	_change_look(4)


func _on_muckDirect_pressed():
	_change_look(6)
