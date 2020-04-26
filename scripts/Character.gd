extends KinematicBody2D

var linear_vel = Vector2()
export(int) var speed = 500
export(int) var jump_speed = 700
var gravity = 800

var facing_right = true

onready var playback = $AnimationTree.get("parameters/playback")

func _ready():
	$Attack.connect("area_entered", self, "on_enemy_entered")

func on_enemy_entered(area: Area2D):
	if area.is_in_group("Enemy"):
		area.take_damage(40)

func set_attack(value: bool):
	$Attack/CollisionShape2D.disabled = !value

func _physics_process(delta):
	
	# Physics
	
	#Gravity
	linear_vel.y += delta * gravity
	
	
	linear_vel = move_and_slide(linear_vel, Vector2(0, -1))
	
	var on_floor = is_on_floor()
	
	if on_floor:
		if Input.is_action_just_pressed("jump"):
			linear_vel.y = -jump_speed
		
	
	var target_vel = (Input.get_action_strength("right") - Input.get_action_strength("left")) * speed
	
	linear_vel.x = lerp(linear_vel.x, target_vel, 0.25)
	
	if on_floor:
		if Input.is_action_just_pressed("attack") or playback.get_current_node() == "attack":
			linear_vel.x = 0
	
	# Animation
	
	if on_floor:
		if abs(linear_vel.x) > 10.0 or target_vel != 0:
			playback.travel("run")
			$AnimationTree.set("parameters/run/TimeScale/scale", 2 * abs(linear_vel.x)/speed)
		else:
			playback.travel("idle")
	else:
		if linear_vel.y > 0:
			playback.travel("fall")
		else:
			playback.travel("jump")
	
	# This is placed last in order to overwrite the current state
	if Input.is_action_just_pressed("attack"):
		playback.travel("attack")
	
	if Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		if facing_right:
			scale.x = -1
		facing_right = false
	if Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		if not facing_right:
			scale.x = -1
		facing_right = true

func _on_Continue_pressed():
	pass # Replace with function body.


func _on_Retry_pressed():
	pass # Replace with function body.


func _on_Quit_pressed():
	pass # Replace with function body.
