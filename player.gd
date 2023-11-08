extends CharacterBody3D

@export var enemy : CharacterBody3D
@export var bullet : PackedScene
@export var camera : Marker3D
@onready var camera_camera =camera.get_node("Camera")
@onready var cursor = $Cursor
@onready var eyes = $eyes
@export var level : Node3D

const speed : float = 1000.0
const jump_velocity : float = 4.5
var movement_velocity: Vector3
var camera_input : float = 0.0
var mouse_sensitiviy : float = 0.01

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	pass

func _physics_process(delta) -> void:

	camera_follows_player()
#	camera_rotation()
	look_at_cursor()
	var input := Vector3.ZERO
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_action_just_pressed("shoot"):
		shoot_weapon()
	
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	
	velocity.x = input.x * speed * delta
	velocity.z = input.z * speed * delta
	
	move_and_slide()
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_input = -event.relative.x * mouse_sensitiviy
	pass
	
func camera_follows_player() -> void:
	var player_pos = global_transform.origin
	camera.global_transform.origin = player_pos
	pass

func camera_rotation() -> void:
	#rotate_x(camera_input[0])
	rotate_y(camera_input)
#    camera.rotation.x = clamp(
#        pitch_pivot.rotation.x,
#        deg_to_rad(-30),S
#        deg_to_rad(30)
#    )
#    twist_input = 0.0
#    pitch_input = 0.0
	pass

func look_at_cursor():
	# Create a horizontal plane, and find a point where the ray intersects with it
	var player_pos = global_transform.origin
	var dropPlane  = Plane(Vector3(0, 1, 0), player_pos.y)
	# Project a ray from camera, from where the mouse cursor is in 2D viewport
	var ray_length = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera_camera.project_ray_origin(mouse_pos)
	var to = from + camera_camera.project_ray_normal(mouse_pos) * ray_length
	var cursor_pos = dropPlane.intersects_ray(from,to)
	
	# Set the position of cursor visualizer
	cursor.global_transform.origin = cursor_pos + Vector3(0,1,0)
	
	# Make player look at the cursor
	look_at(cursor_pos, Vector3.UP)
	pass


func shoot_weapon() -> void:
#	var b = bullet.instantiate()
#	dd_child(b)
#	b.global_transform.origin = eyes.global_transform.origin

# Assuming 'world_node' is a path or reference to the node with the instantiate_bullet function.
	level.instantiate_bullet(global_transform.origin, global_transform.basis.get_euler())


	pass

# Only detects other Areas. Might be useful
func _on_area_3d_area_entered(area) -> void:
	if area:
		print("Enter: " + str(area))
	else:
		print("Nothing enter")
	pass

func _on_area_3d_area_exited(area) -> void:
	if area:
		print("Exit: " + str(area))
	else:
		print("Nothing exit")
	pass

# detects Bodies
func _on_area_3d_body_entered(body) -> void:
	if body:
		print("Enter: " + str(body.collision_layer))
		#print("Enter: " + str(body))
		#if body == enemy:
		#	print("Enemy entered the field")
	else:
		print("Nothing enter")
	pass

func _on_area_3d_body_exited(body) -> void:
	if body:
		# print("Exit: " + str(body))
		print("Exit: " + str(body.collision_layer))
		#if body == enemy && body.collision_layer == 3:
		#	print("Enemy exited the field")
	else:
		print("Nothing exit")
	pass
