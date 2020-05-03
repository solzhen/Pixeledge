extends CollisionShape2D

# Declare member variables here. Examples:
# var a = 2

var knockback = Vector2()
var damage = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_parent().connect("body_entered", self, "on_enemy_entered")
	knockback.x = 100
	knockback.y = -100

func on_enemy_entered(body: KinematicBody2D):
	if body and body.is_in_group("Enemy"):
		var streak = get_parent().get_parent().streak
		body.take_damage(min(damage*streak,10))
		body.take_knockback(knockback*streak)	
		if streak < 3:
			get_parent().get_parent().take_damage((20*rand_range(1,14)))
		
		
	
func e_h():
	self.disabled = false
	
func d_h():
	self.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
