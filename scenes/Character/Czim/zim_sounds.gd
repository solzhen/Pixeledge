extends Node
#Este script supuestamente debería detener los efectos de audio relacionados a un personaje si  la animación es cortada.
onready var playback = ""
var anim=""
var sound=null
func _ready():
	pass
	#conectar anim con AnimationTree

func _process(delta):
	anim=get_parent().get("parameters/playback").get_current_node()
	if $wave_shock.playing==true:
		if anim ==("hurt"): 
			$wave_shock.stop()
	if $slash1.playing==true:
		if  anim == ("hurt"):
			$slash1.stop() 
	if $jump.playing==true:
		if  anim != ("jump") and anim !=("jump_start"):
			$jump.stop() 
	if $shock1.playing==true:
		if anim ==("hurt"): 
			$shock1.stop()
	if $shock2.playing==true:
		if anim ==("hurt"): 
			$shock2.stop()
	if $strike2.playing==true:
		if anim ==("hurt"): 
			$strike2.stop()
	if $strike.playing==true:
		if anim ==("hurt"): 
			$strike.stop()
