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
	player1.connect("death",$Main,"end")
	player2.connect("death",$Main,"end")	
	add_child(player1)
	add_child(player2)

func end(player_index):
	get_tree().change_scene("res://scenes/Character Select.tscn")

func _on_Quit_to_Menu_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")


func _on_Settings_pressed():
	pass # Replace with function body.
