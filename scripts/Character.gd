extends KinematicBody2D

const BASIC_NEUTRAL = 0
const SPECIAL_NEUTRAL = 0
const FINAL = 0

var max_jump_steps = 10

var linear_vel = Vector2()
export(int) var speed = 500
export(int) var jump_speed = 200
var gravity = 800

var facing_right = true

onready var playback = $AnimationTree.get("parameters/playback")

func _ready():
# warning-ignore:return_value_discarded
	pass

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
	
	# Physics
		
	#Gravity
	linear_vel.y += delta * gravity		
	
	linear_vel = move_and_slide(linear_vel, Vector2(0, -1))
	
	var on_floor = is_on_floor()
	
	# Jump
	
	if on_floor:
		max_jump_steps = 10
		if j_jump:
			linear_vel.y = -jump_speed
	else:
		if r_jump:
			max_jump_steps = 0
		if h_jump and max_jump_steps > 0:
			max_jump_steps -= 1
			linear_vel.y -= jump_speed*max_jump_steps*0.05
		
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
	
	if left and not right:
		if facing_right:
			scale.x = -1
		facing_right = false
	if right and not left:
		if not facing_right:
			scale.x = -1
		facing_right = true

func _on_Continue_pressed():
	pass # Replace with function body.


func _on_Retry_pressed():
	pass # Replace with function body.


func _on_Quit_pressed():
	pass # Replace with function body.
