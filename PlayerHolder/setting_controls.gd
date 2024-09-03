extends CanvasLayer
var is_paused = false setget set_is_paused
	
func set_is_paused(value):
	is_paused = value
	$Popup.visible = is_paused


func _on_Resume_pressed():
	$Popup.visible = !is_paused


func _on_FullScreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen
	
