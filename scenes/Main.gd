extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var scene = load("res://scenes/Character.tscn")
	var player1 = scene.instance()
	player1.position.x = 215
	player1.position.y = 300
	player1.player_index = 1
	player1.set_name("Player1")
	add_child(player1)
	var player2 = scene.instance()
	player2.position.x = 600
	player2.position.y = 300
	player2.player_index = 2
	player2.set_name("Player2")
	add_child(player2)

