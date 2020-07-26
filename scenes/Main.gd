extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready main")
	print (Global.player_1)
	print (Global.player_2)
	
	var sam = load("res://scenes/Character/Gatosan.tscn")
	var babosa = load("res://scenes/Character/Babosa.tscn")
	var legoshitaro= load("res://scenes/Character/Legoshitaro.tscn") #Legoshitaro.tscn
	var czim = load("res://scenes/Character/Czim.tscn")
	
	var chars = [legoshitaro, sam, babosa, czim] #legoshitaro	
	
	var player1 = chars[Global.player_1 - 1].instance()
	var player2 = chars[Global.player_2 - 1].instance()
	
	player1.position.x = 200
	player1.position.y = 300
	player1.player_index = 1
	player1.set_name("Player1")
	
	player2.position.x = 750
	player2.position.y = 300
	player2.player_index = 2
	player2.set_name("Player2")
	
	player1.connect("health_update", $UI, "health_update_p1")
	player2.connect("health_update", $UI, "health_update_p2")
	
	add_child(player1)
	add_child(player2)
