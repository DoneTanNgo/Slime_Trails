extends Node2D
var timer = 10
var timer_active = false
const TIMER_TIME = 10

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	start_timer()
	
func _process(delta):
	if (timer_active):
		timer -= delta
		if (timer <= 0):
			timer_active = false
			queue_free()

func start_timer() -> void:
	timer = TIMER_TIME
	timer_active = true

func _on_Area2D_area_entered(area):
	if(area.is_in_group("player_group")):
		Stats.emit_signal("dectect_damage",5)
