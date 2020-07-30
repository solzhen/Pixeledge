extends Control

var Player1_char = Global.player_1
var Player2_char = Global.player_2
var P1_life = 0
var P2_life = 0
var score=[Global.score_p1,Global.score_p2]
var rounds=Global.N_of_rounds

onready var player1 = get_node('res://scenes/main/player1')
onready var player2 = get_node('res://scenes/main/player2')

onready var anim_playerp1 = get_node("AnimationPlayer")
onready var anim_playerp2 = get_node("AnimationPlayer2")

onready var  parry_p1 = get_node("Parry_P1")
onready var  parry_p2 = get_node("Parry_P2")

onready var puntaje_p1 = get_node("p1_lifebar/puntaje_p1")
onready var puntaje_p2 = get_node("p2_lifebar/puntaje_p2")

var timer_parry_p1 = 0
var timer_parry_p2 = 0
var parry_p1_ready = true
var parry_p2_ready = true
var victory_p1 = null
var victory_p2 = null
var victory = 3
var info_rondas_p1=''
var info_rondas_p2=''
onready var valor_vida_p1 = get_node("p1_lifebar/textura_P1")
onready var valor_vida_p2 = get_node("p2_lifebar/textura_P2")
# Called when the node enters the scene tree for the first time.

func _ready():
	print('rondas: '+str(rounds))
	print("score: "+str(score[0])+' vs '+str(score[1]))
	parry_p1.play('Lleno')
	parry_p2.play('Lleno')
	actualizar_vida(100,100)
	if Player1_char < 3:
		anim_playerp1.play("terrestre1")
		info_rondas_p1="Terrestre "+str(rounds)+" "
		puntaje_p1.play(info_rondas_p1+str(score[0]))
	else:
		anim_playerp1.play("alien")
		info_rondas_p1="Alien "+str(rounds)+" "
		puntaje_p1.play(info_rondas_p1+str(score[0]))
	if Player2_char < 3:
		anim_playerp2.play("terrestre2")
		info_rondas_p2="Terrestre "+str(rounds)+" "
		puntaje_p2.play(info_rondas_p2+str(score[1]))
	else:
		anim_playerp2.play("alien2") 
		info_rondas_p2="Alien "+str(rounds)+" "
		puntaje_p2.play(info_rondas_p2+str(score[1]))
	pass # Replace with function body.

func actualizar_vida(a,b):
	print('se intento')
	valor_vida_p1.value = a
	valor_vida_p2.value = b
func health_update_p1(value):
	valor_vida_p1.value = value
func health_update_p2(value):
	valor_vida_p2.value = value

func p1_parried():
	parry_p1.play("Vaciar")
	parry_p1_ready = false

func parry_p1_ready():
	parry_p1.play("Llenar")
	parry_p1_ready = true
	
func p2_parried():
	parry_p2.play("Vaciar")
	parry_p2_ready = false
	
func parry_p2_ready():
	parry_p2.play("Llenar")
	parry_p2_ready = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func p1_wins():
	Global.score_p1+=1
	puntaje_p1.play(info_rondas_p1+str(Global.score_p1))
	print("P1 WINS")
	$p1wins.show()
	victory_p1=Timer.new()
	victory_p1.set_one_shot(true)
	victory_p1.set_wait_time(victory)
	victory_p1.connect("timeout",self,"on_p1_victory")
	add_child(victory_p1)
	victory_p1.start() 
	return
func on_p1_victory():
	if score[0]+1 > rounds/2:
		get_tree().change_scene("res://scenes/Character Select.tscn")
	else:
		get_tree().reload_current_scene()
	return
	
func p2_wins():
	Global.score_p2+=1
	puntaje_p2.play(info_rondas_p2+str(Global.score_p2))
	print("P2 WINS")
	$p2wins.show()
	victory_p2=Timer.new()
	victory_p2.set_one_shot(true)
	victory_p2.set_wait_time(victory)
	victory_p2.connect("timeout",self,"on_p2_victory")
	add_child(victory_p2)
	victory_p2.start() 
	return
func 	on_p2_victory():
	if score[1]+1 > rounds/2:
		get_tree().change_scene("res://scenes/Character Select.tscn")
	else:
		get_tree().reload_current_scene()
	return
