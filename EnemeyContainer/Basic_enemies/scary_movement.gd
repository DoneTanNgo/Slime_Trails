extends Sprite
var moving = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if(moving):
		self.position = Vector2(position.x+rand_range(-10,10),position.y+rand_range(-10,10))
