extends KinematicBody2D

var linear_vel = Vector2()
var gravity = 800

var health = 1000 setget set_health
var death = false
var state = 0

func set_health(value):
	health = value
	$ProgressBar.value = value

# Called when the node enters the scene tree for the first time.
func _ready():
	$ProgressBar.max_value = health
	$ProgressBar.value = health
	state = 0

func self_destroy():
	queue_free()

func take_damage(value: int):
	if !death:
		var new_health = max(health - value, 0)
		if health > 0:
			set_health(new_health)
		if new_health == 0:
			death = true
			$AnimationPlayer.play("death")
			
func take_knockback(knockback: Vector2):
	linear_vel = knockback
	pass
	
func _physics_process(delta):
	linear_vel = move_and_slide(linear_vel, Vector2(0, -1))
	linear_vel.x = lerp(linear_vel.x, 0, 0.10)
