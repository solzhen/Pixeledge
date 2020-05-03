extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_shape_entered", self, "on_enemy_entered")

func on_enemy_entered(_body_id: int, body: Node, _body_shape: int, local_shape: int):
	print (local_shape)
	get_child(local_shape).on_enemy_entered(body)

func handle_streak():
	get_parent().streak_handler()
	
func disable_childs():
	for child in get_children():
		child.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
