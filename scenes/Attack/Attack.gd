extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_shape_entered", self, "on_enemy_entered")

func on_enemy_entered(body_id: int, body: Node, body_shape: int, local_shape: int):
	get_child(local_shape).on_enemy_entered(body)
#	match local_shape:
#		0:
#			$BasicNeutral.on_enemy_entered(body)
#		1:
#			$SpecialNeutral.on_enemy_entered(body)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
