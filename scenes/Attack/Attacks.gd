extends Node
export var attack = 0


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
# warning-ignore:function_conflicts_variable
func attack(body: Node, streak: int):
	var min_streak = get_parent().min_streak
	if not body.is_in_group("Character") and not body.is_in_group("Enemy"):
		return
	var damage = get_child(attack).damage
	var knockback = get_child(attack).knockback		
	var knockbackF = 0
	
	if get_parent().facing_right:
		knockbackF=knockback
	else:
		knockbackF=-(knockback)
	knockback=knockbackF
	if self.owner == body:
		if attack == FINAL and streak < min_streak:
			self_harm()			
	elif attack == FINAL:
		if streak < min_streak:
			self_harm()
		else:
			body.handle_attack(damage*streak, knockback*streak)
			
	else:
		get_parent().combo_timer.start()
		get_parent().streak_handler()
		body.handle_attack(damage, knockback)
	


