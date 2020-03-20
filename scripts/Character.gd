extends KinematicBody2D

var linear_vel = Vector2()
export(int) var speed = 500
var gravity = 800

var counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("jump_end")
	$AnimationPlayer.animation_set_next("jump_start", "jump")
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
			$AnimationPlayer.play("jump_start")
			linear_vel.y = -700
		
	
	var target_vel = Vector2()
	if Input.is_action_pressed("left"):
		target_vel.x -= speed
	if Input.is_action_pressed("right"):
		target_vel.x += speed
	
	
	linear_vel.x = lerp(linear_vel.x, target_vel.x, 0.25)
	
	if on_floor:
		if Input.is_action_just_pressed("attack") or $AnimationPlayer.current_animation == "attack":
			linear_vel.x = 0
	
	
	
	# Animation
	
	$AnimationPlayer.playback_speed = 1
	
	if Input.is_action_just_pressed("attack"):
		$AnimationPlayer.play("attack")
	if $AnimationPlayer.current_animation != "attack":
		if on_floor:
			if abs(linear_vel.x) > 10.0:
				$AnimationPlayer.play("run")
				$AnimationPlayer.playback_speed = 2 * abs(linear_vel.x)/speed
			else:
				$AnimationPlayer.play("idle")
		else:
			if linear_vel.y > 0:
				$AnimationPlayer.play("jump_end")
			else:
				if not "jump" in $AnimationPlayer.current_animation:
					$AnimationPlayer.play("jump_start")
				
	
	if Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		$Sprite.scale.x = -3
		$Attack.position.x = -42
	if Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		$Sprite.scale.x = 3
		$Attack.position.x = 42
		

