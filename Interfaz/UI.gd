extends Control

var Player1_char = Global.player_1
var Player2_char = Global.player_2
var P1_life = 0
var P2_life = 0
onready var player1 = get_node('res://scenes/main/player1')
onready var player2 = get_node('res://scenes/main/player2')

onready var anim_playerp1 = get_node("AnimationPlayer")
onready var anim_playerp2 = get_node("AnimationPlayer2")

onready var  parry_p1 = get_node("Parry_P1")
onready var  parry_p2 = get_node("Parry_P2")
var timer_parry_p1 = 0
var timer_parry_p2 = 0
var parry_p1_ready = true
var parry_p2_ready = true

onready var valor_vida_p1 = get_node("p1_lifebar/textura_P1")
onready var valor_vida_p2 = get_node("p2_lifebar/textura_P2")
# Called when the node enters the scene tree for the first time.

func _ready():
	parry_p1.play('Lleno')
	parry_p2.play('Lleno')
	actualizar_vida(100,100)
	if Player1_char < 3:
		anim_playerp1.play("terrestre1")
	else:
		anim_playerp1.play("alien")
	if Player2_char < 3:
		anim_playerp2.play("terrestre2")
	else:
		anim_playerp2.play("alien2") 
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
	timer_parry_p1 = 1
	parry_p1.play("Vaciar")
	parry_p1_ready = false

func recuperar_parry_p1():
	parry_p1.play("Llenar")
	parry_p1_ready = true
	
func p2_parried():
	timer_parry_p2 = 1
	parry_p2.play("Vaciar")
	parry_p2_ready = false
	
func recuperar_parry_p2():
	parry_p2.play("Llenar")
	parry_p2_ready = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer_parry_p1 -= delta
	timer_parry_p2 -= delta
	if timer_parry_p1 < 0 and parry_p1_ready == false:
		recuperar_parry_p1()
	if timer_parry_p2 < 0 and parry_p2_ready == false:
		recuperar_parry_p2()
	pass
	
func p1_wins():
	print("P1 WINS")
	$p1wins.show()
	#get_node("Label").text = "Player 1 wins"
	return
	
func p2_wins():
	print("P2 WINS")
	$p2wins.show()
	#get_node("Label").text = "Player 2 wins"
	return
