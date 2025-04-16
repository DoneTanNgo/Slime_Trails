extends CanvasLayer
var pre_look
var _tree

# @var  Viewport
var _root

# @var  Node
var _currentScene = null

func _ready():
	visible = false

func pre_load(target: String) -> void:
	pass

func change_scene(target: String) -> void:
	visible = true
	GlobalScript.restart = false
	$AnimationPlayer.play("change_scene_moment")
	yield($AnimationPlayer,"animation_finished")
	get_tree().change_scene(target)
	$AnimationPlayer.play_backwards("change_scene_moment")
	yield($AnimationPlayer,"animation_finished")
	visible = false
	
func change_scene_to(target: Object) -> void:
	visible = true
	GlobalScript.restart = false
	$AnimationPlayer.play("change_scene_moment")
	yield($AnimationPlayer,"animation_finished")
	get_tree().change_scene_to(target)
	$AnimationPlayer.play_backwards("change_scene_moment")
	yield($AnimationPlayer,"animation_finished")
	visible = false
