extends Node

var playback=""

func _ready():
	pass # Replace with function body.

func on_animation_play_sound():
	playback=get_parent().get("parameters/playback")

