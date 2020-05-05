extends Node
export var attack = 0

var min_streak = 3

const FINAL = 2

func _ready():
	pass # Replace with function body.
	
func self_harm():
	var self_damage = (20*rand_range(1,14))
	var self_knockback = Vector2()
	self_knockback.x = - get_parent().scale.x * 100
	self_knockback.y = -100
	get_parent().take_damage(self_damage)
	get_parent().take_knockback(self_knockback)

# TODO: HANDLE STREAK (FINAL = 2)
func attack(body: Node, streak: int):
	if not body.is_in_group("Character") and not body.is_in_group("Enemy"):
		return
	var damage = get_child(attack).damage
	var knockback = get_child(attack).knockback		
	if self.owner == body:
		if attack == FINAL and streak < min_streak:
			self_harm()			
		print("hit meself xd")
	elif attack == FINAL:
		if streak < min_streak:
			self_harm()
		else:
			body.handle_attack(damage*streak, knockback*streak)
	else:
		body.handle_attack(damage, knockback)
	
	


