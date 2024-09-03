extends StaticBody2D
var timer = 0.0
var timer_active = true
const TIMER_TIME = 5

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _ready():
	start_timer()

# Called when the node enters the scene tree for the first time.
func _process(delta):
	if (timer_active):
		timer -= delta
		if (timer <= 0):
			timer_active = false
			queue_free()


func start_timer() -> void:
	timer = TIMER_TIME
	timer_active = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
