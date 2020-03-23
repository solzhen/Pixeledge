extends CanvasLayer


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


func _on_Quit_pressed():
	get_tree().quit()
