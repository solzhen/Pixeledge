extends KinematicBody2D

# stats
const max_health = 1000
var health = max_health
var death = false

# dash 
var dash_timer = null
const max_streak_delay = 1.1
const dash_cooldown = 0.4

# combo

var combo_timer = null
var streak = 0

# CONST
const BASIC_NEUTRAL = 0
const SPECIAL_NEUTRAL = 0
const FINAL = 0


# Megaman jump
const max_stepts = 10
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
	$HealthBar.max_value = max_health
	$HealthBar.value = health

func streak_handler():
	streak += 1
	combo_timer.start()
	print (streak)
	
func on_timeout_complete():  #tiempo expirado
	streak = 0

func _enable_hurtbox(attack: int):
	match attack:
		BASIC_NEUTRAL:
			$Attack/BasicNeutral.disabled = false
		SPECIAL_NEUTRAL:
			$Attack/SpecialNeutral.disabled = false
		FINAL:
			$Attack/Final.disabled = false
			
func _disable_hurtbox(attack: int):
	match attack:
		BASIC_NEUTRAL:
			$Attack/BasicNeutral.disabled = true
		SPECIAL_NEUTRAL:
			$Attack/SpecialNeutral.disabled = true
		FINAL:
			$Attack/Final.disabled = true

# Public shorter version
func e_h(attack: int):
	_enable_hurtbox(attack)
	
func d_h(attack: int):
	_disable_hurtbox(attack)
	
func take_damage(value: int):
	if !death:
		health = health - value
		$HealthBar.value = max(health,0)
		playback.travel("hurt")
		if health <= 0:
			death = true

func self_destroy():
	print("dying")
	queue_free()

func _physics_process(delta):
	
	var j_jump = Input.is_action_just_pressed("jump")
	var h_jump = Input.is_action_pressed("jump")
	var r_jump = Input.is_action_just_released("jump")
	var basic = Input.is_action_just_pressed("basic")
	var special = Input.is_action_just_pressed("special")
	var dash = Input.is_action_just_pressed("dash")
	var final = Input.is_action_just_pressed("final")
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var die = Input.is_action_pressed("die")
	
	if die or death:
		death = true
		playback.travel("death")
		return
	
	# Physics
		
	#Gravity
	linear_vel.y += delta * gravity		
	
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
	
	var target_vel = (Input.get_action_strength("right") - Input.get_action_strength("left")) * speed
	
	linear_vel.x = lerp(linear_vel.x, target_vel, 0.25)
	
	if on_floor:
		if basic or playback.get_current_node() == "basic":
			linear_vel.x = 0
	
	# Animation
	
	if on_floor:
		if abs(linear_vel.x) > 10.0 or target_vel != 0:	
			if not right and not left:
				playback.travel("end_run")
			else:
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
	if basic:
		playback.travel("basic")
	if special:
		playback.travel("special")
	if final:
		playback.travel("final")
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
