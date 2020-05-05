extends Node

var knockback = Vector2()
var damage = 50
var stun_time = 20

func _ready():
	knockback.x = 100
	knockback.y = -100
