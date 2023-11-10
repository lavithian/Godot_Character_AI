extends CharacterBody3D

@export var stats : Resource

@export var camera : Marker3D
@onready var camera_camera = camera.get_node("Camera")
@onready var cursor = $Cursor

enum mining_node {
	TREE,
	ROCK,
	NONE
}

var mining_state = mining_node.NONE
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const jump_velocity : float = 4.5

signal health_changed(current_health, max_health)
signal gain_lumber(amount)
signal gain_stone(amount)

func _ready() -> void:
	health_changed.emit(stats.max_health, stats.max_health)
	# initialise_stats()
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
	if Input.is_action_just_released("shoot") and is_on_floor():
		mine_resources()

	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	
	velocity.x = input.x * stats.speed * delta
	velocity.z = input.z * stats.speed * delta

	move_and_slide()
	#print("Player's position: ", position)
	pass
	
func camera_follows_player() -> void:
	var player_pos = global_transform.origin
	camera.global_transform.origin = player_pos
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
	
func take_damage(amount) -> void:
	print("Damage: " + str(amount))
	stats.health -= amount
	# health_changed.emit(stat.health, 100)
	if stats.health < 1:
		player_death()
	pass

func restart() -> void:
	print("Restart!")
	# health_changed.emit(100, 100)
	pass
	
func player_death() -> void:
	print("Player died :(")
	get_tree().change_scene_to_file("res://restart_menu.tscn")
	pass

func mine_resources():
	print("mining")
	if mining_state == mining_node.TREE:
		#mine tree
		print("Near a tree!")
		gain_lumber.emit(1)
		pass
	elif mining_state == mining_node.ROCK:
		#mine rock
		print("Near a rock!")
		gain_stone.emit(1)
		pass
	# check if it is near a resource node
	# should send a signal to the level which keeps the resource data
	# the ui from level should update
	pass

func _on_area_3d_body_entered(body):
	if body.name == "Tree":
		mining_state = mining_node.TREE
	elif body.name== "Rock":
		mining_state = mining_node.ROCK
	pass

func _on_area_3d_body_exited(body):
	if (body.name == "Tree" || body.name == "Rock") && mining_state != mining_node.NONE:
		mining_state = mining_node.NONE
	pass # Replace with function body.
