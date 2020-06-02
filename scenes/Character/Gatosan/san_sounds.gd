extends Node
#Este script supuestamente debería detener los efectos de audio relacionados a un personaje si  la animación es cortada.
onready var playback = ""
var anim=""
	
func _ready():
	pass
	#conectar anim con AnimationTree

func _process(delta):
	anim=get_parent().get("parameters/playback").get_current_node()
	#if $A1.playing==true:
	#	if anim !=("attack"): 
	#		$A1.stop()
	pass
