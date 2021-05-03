extends RayCast

onready var wall_spray = preload("res://Walls/WallSpray.tscn")

func _input(event):
	if Input.is_action_just_pressed("ability"):
		if !get_child(0):
			var ws = wall_spray.instance()
			add_child(ws)
		else:
			get_child(0).queue_free()
