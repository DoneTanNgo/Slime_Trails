extends KinematicBody2D
var _velocity = Vector2.ZERO
var speed_bouns = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _process(delta):
	movement()
	
func movement() -> void:
	var speed = Vector2(200,200)
	var direction = _get_direction()
	_velocity = calculate_velocity(_velocity,direction,speed)		#Momvement Walking and Others
	_velocity = move_and_slide(_velocity)
	if(direction.y>=1):
		$AnimationPlayer.play("forward_walking")
	else:
		$AnimationPlayer.play("backward_walking")
#	if(direction.y==0&& direction.x==0&&!dodging):
#		$AnimationTree.set("parameters/is_moving/current",1)
#	else:
#		$AnimationTree.set("parameters/is_moving/current",0)
#		if(direction.y>1):
#			$AnimationTree.set("parameters/direction/current",0)
#		else:
#			$AnimationTree.set("parameters/direction/current",1)
			
func _get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up"))

func calculate_velocity(linear_velocity: Vector2, direction: Vector2, speed: Vector2) -> Vector2:
	var out:= linear_velocity
	out.x = (speed.x+speed_bouns) * direction.x
	out.y = (speed.y+speed_bouns) * direction.y
	return out

func _input(event):
	if(Input.get_action_raw_strength("Sprint")>0):
		speed_bouns = 200
	else:
		speed_bouns = 0
	
