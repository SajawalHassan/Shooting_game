extends Spatial

onready var raycast = get_parent()
onready var raycast_owner = get_parent().get_owner()
onready var wall = preload("res://Walls/Wall.tscn")

func _ready():
	set_as_toplevel(true)
	global_transform.origin = raycast.get_collision_point()
	
	
func _input(event):
	if Input.is_action_just_released("ability"):
		var w = wall.instance()
		w.global_transform = global_transform
		get_tree().get_root().add_child(w)
		queue_free()
		
		
func _process(delta):
	global_transform.origin = raycast.get_collision_point()
	rotation = raycast_owner.rotation
