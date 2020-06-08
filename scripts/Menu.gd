extends Node2D

func _ready():
	pass


func _on_New_pressed():
	get_tree().change_scene("res://scenes/Character Select.tscn")

func _on_Settings_pressed():
	pass # Replace with function body.


func _on_Quit_pressed():
	get_tree().quit()
