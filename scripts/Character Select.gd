extends Node2D

var icon_size = 156
var x_1 = 14
var x_2 = 186
var x_3 = 363
var x_4 = 540
var y = 429

var LEG_ID = 1
var SAM_ID = 2
var BAB_ID = 3
var ZIM_ID = 4

var rounds=Global.N_of_rounds
# Called when the node enters the scene tree for the first time.
func _ready():
	rounds=0
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position)
		#print(event.button_index)
		var p = event.position
		if p.y >= y and p.y <= y + icon_size:
			if p.x >= x_1 and p.x <= x_1 + icon_size:
				print("Clicking Legoshitaro")
				if event.button_index == 1:
					Global.player_1 = LEG_ID
					$CanvasLayer/legoshitaro.hide()	
					$CanvasLayer/sam.hide()
					$CanvasLayer/babosa.hide()
					$CanvasLayer/czim.hide()
					$CanvasLayer/legoshitaro.show()			
					$CanvasLayer/Label1.text = "Legoshitaro"
				elif event.button_index == 2:
					Global.player_2 = LEG_ID
					$CanvasLayer/legoshitaro2.hide()	
					$CanvasLayer/sam2.hide()
					$CanvasLayer/babosa2.hide()
					$CanvasLayer/czim2.hide()
					$CanvasLayer/legoshitaro2.show()	
					$CanvasLayer/Label2.text = "Legoshitaro"
			if p.x >= x_2 and p.x <= x_2 + icon_size:
				print("Clicking Sam")
				if event.button_index == 1:
					Global.player_1 = SAM_ID
					$CanvasLayer/legoshitaro.hide()	
					$CanvasLayer/sam.hide()
					$CanvasLayer/babosa.hide()
					$CanvasLayer/czim.hide()
					$CanvasLayer/sam.show()
					$CanvasLayer/Label1.text = "Sam"
				elif event.button_index == 2:
					Global.player_2 = SAM_ID
					$CanvasLayer/legoshitaro2.hide()	
					$CanvasLayer/sam2.hide()
					$CanvasLayer/babosa2.hide()
					$CanvasLayer/czim2.hide()
					$CanvasLayer/sam2.show()
					$CanvasLayer/Label2.text = "Sam"
			if p.x >= x_3 and p.x <= x_3 + icon_size:
				print("Clicking Babosa")
				if event.button_index == 1:
					Global.player_1 = BAB_ID
					$CanvasLayer/legoshitaro.hide()	
					$CanvasLayer/sam.hide()
					$CanvasLayer/babosa.hide()
					$CanvasLayer/czim.hide()
					$CanvasLayer/babosa.show()
					$CanvasLayer/Label1.text = "Babosa"
				elif event.button_index == 2:
					Global.player_2 = BAB_ID
					$CanvasLayer/legoshitaro2.hide()	
					$CanvasLayer/sam2.hide()
					$CanvasLayer/babosa2.hide()
					$CanvasLayer/czim2.hide()
					$CanvasLayer/babosa2.show()
					$CanvasLayer/Label2.text = "Babosa"
			if p.x >= x_4 and p.x <= x_4 + icon_size:
				print("Clicking Czim")
				if event.button_index == 1:
					Global.player_1 = ZIM_ID
					$CanvasLayer/legoshitaro.hide()	
					$CanvasLayer/sam.hide()
					$CanvasLayer/babosa.hide()
					$CanvasLayer/babosa.hide()
					$CanvasLayer/czim.show()
					$CanvasLayer/Label1.text = "Czim"
				elif event.button_index == 2:
					Global.player_2 = ZIM_ID
					$CanvasLayer/legoshitaro2.hide()	
					$CanvasLayer/sam2.hide()
					$CanvasLayer/babosa2.hide()
					$CanvasLayer/babosa2.hide()
					$CanvasLayer/czim2.show()
					$CanvasLayer/Label2.text = "Czim"
	if Global.player_1 != 0 and Global.player_2 != 0:
		$CanvasLayer/Button.disabled = false
	#print("Viewport Resolution is: ", get_viewport_rect().size)

func _on_Button_pressed():
	if rounds!=0:
		Global.score_p1 = 0
		Global.score_p2 = 0
		get_tree().change_scene("res://scenes/Main.tscn")
	


func _on_CheckBox_toggled(button_pressed):
	rounds=1
	Global.N_of_rounds=rounds
	$CanvasLayer/Label/CheckBox2.DRAW_PRESSED
	$CanvasLayer/Label/CheckBox3.DRAW_PRESSED
	pass # Replace with function body.


func _on_CheckBox2_toggled(button_pressed):
	rounds=3
	Global.N_of_rounds=rounds
	$CanvasLayer/Label/CheckBox.DRAW_PRESSED
	$CanvasLayer/Label/CheckBox3.DRAW_PRESSED
	pass # Replace with function body.


func _on_CheckBox3_toggled(button_pressed):
	rounds=5
	Global.N_of_rounds=rounds
	$CanvasLayer/Label/CheckBox.DRAW_PRESSED
	$CanvasLayer/Label/CheckBox2.DRAW_PRESSED
	pass # Replace with function body.
