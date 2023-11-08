extends CharacterBody3D

@export var player : Node3D

const speed = 5.0
const orbit_speed : float = 3.0
const lunge_speed : float = 10.0
var in_range : bool = false
var hit_enemy : int = 1
var current_state = state.MOVE


enum state {
	MOVE,
	ORBIT,
	LUNGE,
	ATTACK
}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	#print("Current state: " + name + ' ' + str(current_state))
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if player:
		if is_on_floor():
			match current_state: 
				state.MOVE:
					move_to_player()
				state.ORBIT:
					orbit_player()
				state.LUNGE:
					lunge_player()
				state.ATTACK:
					attack_player()
	move_and_slide()

func move_to_player():
	look_at(player.global_position)
	var direction = global_position.direction_to(player.global_position)
	if direction:
		velocity = direction * speed
		
func orbit_player():
	var direction = (global_transform.origin - player.global_transform.origin).normalized()
	var orbit_direction = Vector3(
		0,
		hit_enemy,
		0
	).cross(direction).normalized()
	velocity = orbit_direction * orbit_speed
	look_at(player.global_transform.origin, Vector3.UP)

func lunge_player():
	# make a lunge at the player
	velocity.x = 0
	velocity.z = 0
#	print("Lunge!")
	await get_tree().create_timer(1).timeout
	var direction = global_position.direction_to(player.global_position)
	if direction:
		velocity = direction * lunge_speed
	await get_tree().create_timer(1).timeout
	velocity.x = 0
	velocity.z = 0
	if in_range:
		current_state = state.ATTACK
	else:
		current_state = state.MOVE

func attack_player():
	# attack player
	#print("Attack!")
	current_state = state.MOVE
	pass

func _on_area_3d_body_entered(body):
	#print("Enemy Enter: " + str(body))
	if body.name == "Player":
		in_range = true
	current_state = state.ORBIT

func _on_area_3d_body_exited(body):
	if body.name == "Player":
		in_range = false
	current_state = state.MOVE

func _on_area_3d_area_entered(area):
	if area.collision_layer == 8:
		hit_enemy = -hit_enemy

func _on_timer_timeout():
	var rng = RandomNumberGenerator.new().randi_range(0, 4)
	if rng == 3:
		if current_state == state.ORBIT:
			current_state = state.LUNGE
	pass # Replace with function body.
