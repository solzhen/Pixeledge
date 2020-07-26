extends Control

var Player1_char = Global.player_1
var Player2_char = Global.player_2
var P1_life = 0
var P2_life = 0
onready var player1 = get_node('res://scenes/main/player1')
onready var player2 = get_node('res://scenes/main/player2')

onready var anim_playerp1 = get_node("AnimationPlayer")
onready var anim_playerp2 = get_node("AnimationPlayer2")

onready var valor_vida_p1 = get_node("p1_lifebar/textura_P1")
onready var valor_vida_p2 = get_node("p2_lifebar/textura_P2")
# Called when the node enters the scene tree for the first time.

func _ready():
	actualizar_vida(100,100)
	if Player1_char < 3:
		print('p1 terrestre')
		anim_playerp1.play("terrestre1")
	else:
		print('p1 alien')
		anim_playerp1.play("alien")
	if Player2_char < 3:
		print('p2 terrestre')
		anim_playerp2.play("terrestre2")
	else:
		print('p2 alien')
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
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
