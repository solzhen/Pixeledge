extends CanvasLayer

var sounds=null
var audio=0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	hide(true)


func hide(value: bool):
	$Panel.visible = !value
	$VBoxContainer.visible = !value


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		hide(false)


func _on_Continue_pressed():
	get_tree().paused = false
	hide(true)


func _on_Retry_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	pass

func _on_Quit_to_Character_Select_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/Character Select.tscn")

func _on_Quit_to_Menu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/Menu.tscn")

func _on_Windowed_pressed():
	OS.window_fullscreen = !OS.window_fullscreen

func _on_HSlider_value_changed(value):
	audio=value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), audio)
	
func _on_sound_value_changed(value):
	audio=value
	pass # Replace with function body.
