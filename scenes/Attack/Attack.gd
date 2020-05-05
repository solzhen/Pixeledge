extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", self, "handle_box")

func handle_box(area: Node):
	print(self.owner.Attacks)

func handle_streak():
	get_parent().get_parent().streak_handler()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
