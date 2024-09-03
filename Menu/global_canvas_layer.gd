extends Node
var fps_on = false
onready var fps_counter = get_node("CanvasLayer/Label")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#func _ready():
#	self.visible = false
	
func _process(delta):
	if(fps_on):
		fps_counter.visible = true
		fps_counter.text = "FPS: %s" % [Engine.get_frames_per_second()]
	else:
		fps_counter.visible = false
