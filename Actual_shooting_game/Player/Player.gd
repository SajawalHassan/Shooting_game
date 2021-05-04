extends KinematicBody

const ADS_SPEED = 5

# Movement variables
var speed = 10
var acceleration = 20
var gravity = 15

# Jumps variables
var jump = 7
var jump_num = 0

# Sprinting variables
var sprint_speed = 15
var sprint_jump = 5

var wall_normal

# Mouse variables
var mouse_sensitivity = 0.09
var mouse_pitch = 90

# Movment Vectors
var velocity = Vector3()
var fall = Vector3()
var direction = Vector3()

# Firing variable
var shoot_damage = 40

onready var head = $Head
onready var camera = $Head/Camera

onready var raycast = $Head/Camera/RayCast
onready var anim_player = $Head/Camera/AnimationPlayer

onready var gun_cam = $Head/Camera/ViewportContainer/Viewport/GunCam

onready var bullet = preload("res://Weapons/Bullet.tscn")
onready var muzzle = $Head/Camera/Hand/Gun/Muzzle

# To set the mouse invisible
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# To move the mouse on the x and y axis
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-mouse_pitch), deg2rad(mouse_pitch))
	
	if Input.is_action_pressed("ADS_fire"):
		speed = ADS_SPEED
		sprint_speed = ADS_SPEED
		
	else:
		speed = 10
		sprint_speed = 15
		
# To exit
func _unhandled_input(event):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
		
# Double jump (mainly)
func _process(delta):
	if is_on_floor():
		jump_num = 0
		

	gun_cam.global_transform = camera.global_transform
		

# Firing by checking if the raycast is colliding with an enemy
func fire():
	if Input.is_action_just_pressed("fire"):
		if !anim_player.is_playing():
			if raycast.is_colliding():
				var b = bullet.instance()
				muzzle.add_child(b)
				b.look_at(raycast.get_collision_point(), Vector3.UP)
				b.shoot = true
#				var target = raycast.get_collider()
#				if target.is_in_group("Enemy"):
#					target.health -= shoot_damage
				anim_player.play("fire")
			else:
				anim_player.stop()

				
				

remote func _set_position(pos):
	global_transform.origin = pos

# To move
func _physics_process(delta):
	
#	wall_run()
	fire()
	
	direction = Vector3()
	
# Applying gravity
	if !is_on_floor():
		fall.y -= gravity * delta
		
# Making the player jump
	if Input.is_action_pressed("jump") and is_on_floor():
		if jump_num == 0:
			fall.y = jump
			jump_num = 1
			
	if Input.is_action_just_pressed("jump") and !is_on_floor():
		if jump_num == 1:
			fall.y = jump
			jump_num = 2
	
# Making the player sprint
	if Input.is_action_pressed("sprint") and Input.is_action_pressed("move_forward"):
		speed = sprint_speed
		jump = sprint_jump
	
# Moving the player
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
		
	elif Input.is_action_pressed("move_backwards"):
		direction += transform.basis.z
	
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
		
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
		
# To move at the same speed even when we move diagnaly
	direction = direction.normalized()
	
# Making the movement smoother with linear_interpolate
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	

	velocity = move_and_slide(velocity, Vector3.UP)
	move_and_slide(fall, Vector3.UP)
	











