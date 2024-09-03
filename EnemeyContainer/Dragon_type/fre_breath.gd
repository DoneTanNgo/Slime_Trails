extends RayCast2D

var is_casting := false setget set_is_casting
var Max_length = 2000

func _ready() -> void:
	is_casting = false
	_physics_process(false)

#func _unhandled_input(event):
#	if(Input.is_action_just_pressed("space_bar")):
#		self.is_casting = !is_casting
#		fire_moving("right")

func _physics_process(delta):
	var castpoint := cast_to
#	var mouse_position = get_local_mouse_position()
	var max_cast_range = Vector2.DOWN * Max_length
	cast_to = max_cast_range
	
	if(self.is_colliding()&&!get_collider().is_in_group("map_group")):
		$end.global_position = get_collision_point()
		castpoint = to_local(get_collision_point())
		if(get_collider().is_in_group("player_group")):
			print(get_collider())
			get_collider().emit_signal("damaged",5)
	else:
		$end.global_position = cast_to
	$Line2D.points[1] = castpoint


func set_is_casting(cast: bool) -> void:
	is_casting = cast
	if is_casting:
		appear()
	else:
		dissapear()
	set_physics_process(is_casting)

func appear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D,"width",0,50.0,0.2)
	$Tween.start()

func dissapear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D,"width",50,0,0.1)
	$Tween.start()

func full_fire_moving(rot: String) -> void:
	if(rot == "right"):
		self.is_casting = !is_casting
		$Fire_breath_animation.play("full_screen_fire_RtoL")
		yield($Fire_breath_animation,"animation_finished")
		self.is_casting = !is_casting
	else:
		self.is_casting = !is_casting
		$Fire_breath_animation.play("full_screen_fire_LtoR")
		yield($Fire_breath_animation,"animation_finished")
		self.is_casting = !is_casting
	
func fire_moving(rot: String) -> void:
	if(rot == "right"):
		self.is_casting = !is_casting
		$Fire_breath_animation.play("Right_fire")
		yield($Fire_breath_animation,"animation_finished")
		self.is_casting = !is_casting
	else:
		self.is_casting = !is_casting
		$Fire_breath_animation.play("Left_fire")
		yield($Fire_breath_animation,"animation_finished")
		self.is_casting = !is_casting
		

