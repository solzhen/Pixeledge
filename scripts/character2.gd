extends KinematicBody2D

var jumpvelocity = 150.0
var gravityscale = 200.0
var anim = ""
var gravity      = 600
var linear_vel = Vector2()
var jump  = -320
var knockback = Vector2()

# Variables relacionadas con deteccion de combo ###################
var timer= null
var max_streak_delay = 2
var streak1= 0 setget set_streak
var on_combo=false  #aun no tiene uso
var new_streak=0 # strike points
var multiplier=1 #hay q definir la función multiplier

#variables relacionadas con attack cancel
var b_timer=null
var cancel_charger = 2
var cancel_status = 1  setget set_cancel_status #cancel points 
var current_status=cancel_status #no sé por que metí esto....
var min_cancel = 12 #Bajo este numero, no se restan cancel points por daño


#resistencia personaje
var ded=false
var health = 1001 setget set_health # health points
var helt = null
var death = false

export(int) var walk_vel = 220

onready var playback = $AnimationTree.get("parameters/playback")



####### Resistencia personaje
func set_health(value):
	playback.travel("hurt")
	health=value	
	if health < 0.0:  #se murio la cosa
		print("ded")
		ded=true
		playback.travel("hurt")
		playback.travel("ded")
		#se detienen los timer
		timer.stop()
		b_timer.stop()
		self.set_physics_process(false)
		$StreakBar.queue_free()
		$CancelBar.queue_free()
		$HealthBar.queue_free()
	print(health)
	$HealthBar.value = value
	b_timer.start()###reinicio timer cancel
	if cancel_status>min_cancel:
		set_cancel_status(cancel_status-6)
### Parche con otro personaje		
func take_damage(value: int):
	if !ded:
		health = health - value
		set_health(health)
	else:
		return
func take_knockback(knockback: Vector2):
	linear_vel = knockback
	pass
	
	
####### barra atack cancel##################
func set_cancel_status(value):
	if ded:
		return
	if value<59 and value>0:    #si e es positivo
		if value<current_status:
			cancel_status=current_status
			value=current_status
		else:
			cancel_status=current_status+value
			value=cancel_status
			b_timer.start()
	elif value>59:
		value=60
	else:         #si se hace 0
		value=0
	$CancelBar.value = value

	

######## Barra de carga del combo			
func set_streak(value):
	if ded:
		return
	else:
		print(streak1)
		streak1=value
		$StreakBar.value = value	
	
		
func _ready():
####### Construccion del timer
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(max_streak_delay)
	timer.connect("timeout",self,"on_timeout_complete")
	add_child(timer)
#### Timer del cancel
	b_timer=Timer.new()
	b_timer.set_one_shot(true)
	b_timer.set_wait_time(cancel_charger)
	b_timer.connect("timeout",self,"on_cancel_charged")
	add_child(b_timer)
	
	b_timer.start() #inicializacion del timer
	
	$Attacks.connect("body_shape_entered", self, "on_enemy_entered")


#barra de cancel al máximo
func on_cancel_charged():   #cancel cargado al 100%
	if cancel_status<59:    #mientras no se alcance la carga máxima
		b_timer.start()
		set_cancel_status(cancel_status+1)
	else:                  #si se trata de superar la carga máxima
		set_cancel_status(60)

func on_timeout_complete():  #timer de combo expirado
	on_combo=false
	set_streak(0)
	
	
func on_enemy_entered(_body_id: int, body: Node, _body_shape: int, local_shape: int):
	if body.is_in_group("Enemy"):
		if playback.get_current_node()=="Finisher":  #caso de lanzar el finisher 
			if streak1<5:									#El combo es muy bajo
				helt=health-(20*rand_range(1,14))
				if cancel_status>min_cancel:
					set_cancel_status(cancel_status-4)
				b_timer.start()
				set_health(helt)
				body.take_damage(30)
				body.take_knockback(knockback)
			if streak1>4: 								#el combo es aceptable
				body.take_damage(30*streak1)#cambiar streak1 por multiplier cuando este listo
		elif playback.get_current_node()=="atack2":
			body.take_damage(50)					#ataque pesado
			body.take_knockback(knockback)	
			set_cancel_status(cancel_status+1)
			timer.start()
			new_streak=(streak1 +1)
			set_streak(new_streak)
		else:                                             #Ataque normal
			body.take_damage(20)
			body.take_knockback(knockback)
		#inicio/reinicio timer
			set_cancel_status(cancel_status+1)
			timer.start()
			new_streak=(streak1 +1)
			set_streak(new_streak)
			
#otro personaje 
	if body.is_in_group("character"):
		if playback.get_current_node()=="Finisher":  #caso de lanzar el finisher 
			if streak1<5:									#El combo es muy bajo
				helt=health-(20*rand_range(1,14))
				if cancel_status>min_cancel:
					set_cancel_status(cancel_status-4)
				b_timer.start()
				set_health(helt)
				body.take_damage(30)
				body.take_knockback(knockback)
			if streak1>4: 								#el combo es aceptable
				body.take_damage(30*streak1)#cambiar streak1 por multiplier cuando este listo
				body.take_knockback(knockback)
		elif playback.get_current_node()=="atack2":
			body.take_damage(50)						#ataque pesado
			body.take_knockback(knockback)
			set_cancel_status(cancel_status+1)
			timer.start()
			new_streak=(streak1 +1)
			set_streak(new_streak)
		else:                                             #Ataque normal
			body.take_damage(20)
			body.take_knockback(knockback)
		#inicio/reinicio timer
			set_cancel_status(cancel_status+1)
			timer.start()
			new_streak=(streak1 +1)
			set_streak(new_streak)	
func _process(delta):
	pass


func _physics_process(delta):
	
	linear_vel.y +=delta * gravity #gravedad
	linear_vel = move_and_slide(linear_vel, Vector2(0,-1))
	
	var move_left    = Input.is_action_pressed("left2")
	var move_right   = Input.is_action_pressed("right2")
	var jumping      = Input.is_action_just_pressed("jump2")
	var basic        = Input.is_action_just_pressed("basic2")
	var special      = Input.is_action_just_pressed("special_atack2")
	var finisher     = Input.is_action_just_pressed("finisher2")
	var target_vel=Vector2()
	
	var on_floor = is_on_floor()
	
	
	####################movimientos######################################
	if move_left:
		target_vel.x=-walk_vel
			
	if move_right:
		target_vel.x=walk_vel
		
	if  on_floor:
		if jumping:
			linear_vel.y= jump
			

	
	linear_vel.x=lerp(linear_vel.x,target_vel.x,0.2)
	
	##########################animacion########################################
	if on_floor and (basic or special or finisher):
		if basic:
			if streak1>6: 
				playback.travel("autocombo_random1")
				streak1=streak1-4
				linear_vel.x=0
			else:
				playback.travel("atack1")
				linear_vel.x = 0

		if special: 
			playback.travel("atack2")
			linear_vel.x = 0
		if finisher:
			playback.travel("Finisher")
			linear_vel.x = 0
			
	elif on_floor:
		if Input.is_action_just_pressed("ui_end"):   #Hacerse la suicidación
			playback.travel("hurt")
			helt=health-100
			set_health(helt)
			
		if abs(linear_vel.x) > 10.00:
			playback.travel("Walk")
			if linear_vel.y !=0:
				playback.travel("jump_start")
		elif linear_vel.y !=0:
			playback.travel("jump_start")
		else:
			playback.travel("idle")			
	##jump kick

	else:
		if linear_vel.y<0:
			if basic:
				playback.travel("Air_atack1")
			if special:
				playback.travel("atack2_2")	
		if linear_vel.y > 0:
			playback.travel("jump_air")
			if basic:
				playback.travel("Air_atack1")	
			if special:
				playback.travel("atack2_2")
		if linear_vel.y==0:
			playback.travel("jump_down")
			


###orientacion espacial
	if Input.is_action_pressed("left2") and not Input.is_action_pressed("right2"):
		$sprite.scale.x = -1.5
		$Attacks.scale.x = -1
		
	if Input.is_action_pressed("right2") and not Input.is_action_pressed("left2"):
		$sprite.scale.x = 1.5
		$Attacks.scale.x = 1
