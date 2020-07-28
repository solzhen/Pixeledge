extends KinematicBody2D

export var player_index = 0

# stats
var max_health = 1000
var health = max_health
var death = false

signal health_update(value)

# dash 
var dash_timer = null
var dash_cooldown = 0.4

# combo

var combo_timer = null
var streak = 0
var max_streak_delay = 1.4
var min_streak = 3
var max_streak = 50

# parry
var p_timer=null
var parry_step=0.5
var cancel_min=10
var cancel_max=60

# state
const NEUTRAL = 0
const STARTUP = 1
const ATTACKING = 2
const HITLAG = 3
const PARRYING = 4
const STUNNED = 5
const AIRBOUND = 6
const DASHING = 7
const TRIPPING = 8
export var state = NEUTRAL


# Megaman jump
var max_stepts = 10
var jump_steps = max_stepts

var linear_vel = Vector2()
export(int) var speed = 500
export(int) var jump_speed = 200
var gravity = 800

var facing_right = true

onready var playback = $AnimationTree.get("parameters/playback")

func _ready():
	combo_timer = Timer.new()
	combo_timer.set_one_shot(true)
	combo_timer.set_wait_time(max_streak_delay)
	combo_timer.connect("timeout",self,"on_timeout_complete")
	add_child(combo_timer)
	dash_timer = Timer.new()
	dash_timer.set_one_shot(true)
	dash_timer.set_wait_time(dash_cooldown)
	add_child(dash_timer)
	#### Timer del parry
	p_timer=Timer.new()
	p_timer.set_one_shot(true)
	p_timer.set_wait_time(parry_step)
	p_timer.connect("timeout",self,"on_parry_charged")
	add_child(p_timer)
	p_timer.start() 
	$HealthBar.max_value = max_health
	$HealthBar.value = health
	$StreakBar.max_value = max_streak
	$StreakBar.value = 0
	$CancelBar.max_value = cancel_max
	$CancelBar.value = cancel_min

func streak_handler():
	streak += 1
	combo_timer.start()
	$StreakBar.value = streak
func 	on_parry_charged():
	if $CancelBar.value<(cancel_max+1):
		$CancelBar.value+=1
	else:
		$CancelBar.value=cancel_max	
	p_timer.start()
func on_timeout_complete():  #tiempo expirado
	streak = 0
	$StreakBar.value=streak
func take_damage(value: int):
	if !death:
		streak=0
		$StreakBar.value=streak
		set_health(health - value)
		$HealthBar.value = max(health,0)
		playback.travel("hurt")
		if health <= 0:
			death = true
			
func take_knockback(knockback: Vector2):
	linear_vel = knockback
	pass
	
func self_destroy():
	print("dying")
	queue_free()

func _physics_process(delta):	
	
	
	var j_jump = Input.is_action_just_pressed("jump" + "_" + str(player_index))
	var h_jump = Input.is_action_pressed("jump" + "_" + str(player_index))
	var r_jump = Input.is_action_just_released("jump" + "_" + str(player_index))
	var basic = Input.is_action_just_pressed("basic" + "_" + str(player_index))
	var special = Input.is_action_pressed("special" + "_" + str(player_index))
	var dash = Input.is_action_just_pressed("dash" + "_" + str(player_index))
	var final = Input.is_action_just_pressed("final" + "_" + str(player_index))
	var right = Input.is_action_pressed("right" + "_" + str(player_index))
	var left = Input.is_action_pressed("left" + "_" + str(player_index))
	var die = Input.is_action_pressed("die" + "_" + str(player_index))
	var parry =  Input.is_action_pressed("parry" + "_" + str(player_index))
	
	if (position.x > 1120 or position.x <-100 or position.y > 700) and death == false:
		death = true
		print('se murio')
	## TODO: parry animation, set parry state, change parry handle on attacker
	if die or death:
		death = true
		playback.travel("death")
		return
	
	# Physics
		
	#Gravity
	if  playback.get_current_node() != "parry":
		linear_vel.y += delta * gravity		
	else: 
		linear_vel.y=0
	linear_vel = move_and_slide(linear_vel, Vector2(0, -1))
	
	var on_floor = is_on_floor()
	
	# Jump
	
	if on_floor:
		jump_steps = max_stepts
		if j_jump:
			linear_vel.y = -jump_speed
	else:
		if r_jump:
			jump_steps = 0
		if h_jump and jump_steps > 0:
			jump_steps -= 1
			linear_vel.y -= jump_speed*jump_steps*0.05
		
	# Movement
	
	var target_vel = (Input.get_action_strength("right_" + str(player_index)) - Input.get_action_strength("left_" + str(player_index))) * speed
	
	linear_vel.x = lerp(linear_vel.x, target_vel, 0.25)
	
	if on_floor:
		if basic or playback.get_current_node() == "basic": 
			linear_vel.x = 0
		if basic or playback.get_current_node() == "basic2": 
			linear_vel.x = 0
		if basic or playback.get_current_node() == "combo1":
			linear_vel.x = 0
		if parry or playback.get_current_node() == "parry":
			linear_vel.x = 0
		if special or playback.get_current_node() == "special": 
			linear_vel.x = 0
		if special or playback.get_current_node() == "special2": 
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
	if parry  and playback.get_current_node() != "parry":
		if $CancelBar.value>10:
			playback.travel("parry")
			print($CancelBar.value)
	if basic:
		playback.travel("basic")
	if special:
		playback.travel("special")
	if final:
		playback.travel("final")
	if parry:
		$CancelBar.value -=cancel_min
		if playback.get_current_node() != "parry":
			if facing_right:
				linear_vel.x=speed*3
			else:
				linear_vel.x=-speed*3
	if dash:
		if dash_timer.get_time_left() == 0:
			playback.travel("dash")
			if facing_right:
				linear_vel.x = speed*4
			else:
				linear_vel.x = -speed*4
			if not on_floor:
				linear_vel.y = -100
			dash_timer.start()
			
	if (left or right) and basic: playback.travel("atack2")	
	if playback.get_current_node()=="atack2" and special: playback.travel("special")
	
	if left and not right:
		if facing_right:
			scale.x = -1
			$HealthBar.rect_scale.x *= -1
		facing_right = false
	if right and not left:
		if not facing_right:
			scale.x = -1
			$HealthBar.rect_scale.x *= -1
		facing_right = true

func _on_Continue_pressed():
	pass # Replace with function body.


func _on_Retry_pressed():
	pass # Replace with function body.


func _on_Quit_pressed():
	pass # Replace with function body.


func _on_Attack_body_entered(body):
	#$Sprite/Attack/Hitbox.disabled = true
	$Attacks.attack(body, streak)
	pass # Replace with function body.
	
## TODO: HANDLE STATES, PARRYING, ETC
func handle_attack(damage, knockback):
	self.take_damage(damage)
	self.take_knockback(knockback)
	
func set_health(value):
	health = value
	emit_signal("health_update", 100.0 * value / max_health)
