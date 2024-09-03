extends CanvasLayer
var is_paused = false setget set_is_paused
	
func set_is_paused(value):
	is_paused = value
	$Popup.visible = is_paused

func _on_Video_pressed():
	$Popup/VBoxContainer/Panel/VBoxContainer/Video/setting_video.is_paused = !$Popup/VBoxContainer/Panel/VBoxContainer/Video/setting_video.is_paused


func _on_Controls_pressed():
	$Popup/VBoxContainer/Panel/VBoxContainer/Controls/setting_control.visible = true


func _on_Resume_pressed():
	$Popup.visible = !is_paused
