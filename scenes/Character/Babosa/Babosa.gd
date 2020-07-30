extends KinematicBody2D

export var player_index = 0

# stats
var max_health = 1000
var health = max_health
var death = false

signal health_update(value)
signal player_parried()
signal parry_ready()

signal death()

# dash 
var dash_timer = null
var dash_cooldown = 0.4

# combo

var combo_timer = null
var streak = 0
var max_streak_delay = 1.7
var min_streak = 3
var max_streak = 50

# parry
var p_timer=null
var is_parry_ready=true
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

export var facing_right = true

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
	p_timer.connect("timeout",self,"parry_now_ready")
	add_child(p_timer)
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
	
func on_timeout_complete():  #tiempo expirado
	streak = 0
	$StreakBar.value=streak
	
func 	parry_now_ready(): #contador_parry
	emit_signal("parry_ready")
	is_parry_ready=true
	
	
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
	var basic = Input.is_action_pressed("basic" + "_" + str(player_index))
	var special = Input.is_action_pressed("special" + "_" + str(player_index))
	var dash = Input.is_action_just_pressed("dash" + "_" + str(player_index))
	var final = Input.is_action_just_pressed("final" + "_" + str(player_index))
	var right = Input.is_action_pressed("right" + "_" + str(player_index))
	var left = Input.is_action_pressed("left" + "_" + str(player_index))
	var die = Input.is_action_pressed("die" + "_" + str(player_index))
	var parry =  Input.is_action_just_pressed("parry" + "_" + str(player_index))
	
	## TODO: parry animation, set parry state, change parry handle on attacker
	if (position.x > 1120 or position.x <-100 or position.y > 700) and death == false:
		death = true
		print('se murio')
		
	
	if die or death:
		emit_signal("death")
		death = true
		playback.travel("death")
		return
	
	# Physics
		
	#Gravity
	if  playback.get_current_node() != "parry":
		linear_vel.y += delta * gravity		
	else: 
		linear_vel.y=0
		linear_vel.x=0

	if  playback.get_current_node() == "final":
		if facing_right:
			linear_vel.x=speed*1.5
			linear_vel.y=-1
			pass
		else:
			linear_vel.x=-speed*1.5
			linear_vel.y=-1
			pass
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
		if basic or playback.get_current_node() == "combo1":
			linear_vel.x = 0
		if parry or playback.get_current_node() == "parry":
			linear_vel.x = 0
		if special or playback.get_current_node() == "special": 
			linear_vel.x = 0
		if special or playback.get_current_node() == "special2": 
			linear_vel.x = 0
		if playback.get_current_node()=="final_start" or playback.get_current_node()=="final_end" :
			linear_vel.x=0
	# Animation
	if on_floor:
		if abs(linear_vel.x) > 10.0 or target_vel != 0:	
			playback.travel("run")
			$AnimationTree.set("parameters/run/TimeScale/scale", 2 * abs(linear_vel.x)/speed)
		else:
			playback.travel("idle")
			if j_jump or r_jump:
				playback.travel("jump_start")
	else:
		if final:
			playback.travel("final")
		else:
			if j_jump or r_jump:
				playback.travel("jump_start")
				if linear_vel.y !=0:
					playback.travel("jump")
				if linear_vel.y==0:
					playback.travel("fall")
	
	# This is placed last in order to overwrite the current state
			 

	if parry:
		if is_parry_ready and playback.get_current_node() != "parry":
			emit_signal("player_parried")
			playback.travel("parry")
			p_timer.start()
			is_parry_ready=false
	if basic:
		if  playback.get_current_node() != "combo1":
			playback.travel("basic")
			if streak>3 and   playback.get_current_node() != "combo1":
				playback.travel("combo1")
		pass	
	if special:
		playback.travel("special")
	if final:
		playback.travel("final_end")

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
			
	if (left or right) and basic: playback.travel("basic2")	
	if (left or right) and special: playback.travel("special2")		
	if special and (playback.get_current_node()=="special2" or playback.get_current_node()=="basic2"): 
		playback.travel("special3")	
			
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
	if death: emit_signal(death)

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
