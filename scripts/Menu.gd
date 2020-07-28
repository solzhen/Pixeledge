extends Node2D

func _ready():
	pass


func _on_Versus_pressed():
	get_tree().change_scene("res://scenes/Character Select.tscn")

func _on_Creditos_pressed():
	get_tree().change_scene("res://scenes/Credits.tscn")

func _on_Quit_pressed():
	get_tree().quit()
