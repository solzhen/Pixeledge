extends Node

var knockback = Vector2()
var damage = 100

func _ready():
	knockback.x = 100
	knockback.y = -10
#Este ataque especial solo se puede ejecutar dentro de un combo, 
#como parte de un autocombo o inmediatamente despues de un golpe
