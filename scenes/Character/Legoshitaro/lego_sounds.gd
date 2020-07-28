extends Node
#Este script supuestamente debería detener los efectos de audio relacionados a un personaje si  la animación es cortada.
onready var playback = ""
var anim=""
	
func _ready():
	pass
	#conectar anim con AnimationTree

func _process(delta):
	anim=get_parent().get("parameters/playback").get_current_node()

	if $slosh.playing==true:
		if anim ==("hurt"): 
			$slosh.stop()
	if $slash1.playing==true:
		if  anim == ("hurt"):
			$slash1.stop() 
	if $jump.playing==true:
		if  anim != ("jump") and anim !=("jump_start"):
			$jump.stop() 
	if $shock1.playing==true:
		if anim ==("hurt"): 
			$shock1.stop()
