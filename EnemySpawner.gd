extends Node3D


var enemy_scene_path: String = "res://enemy.tscn"
var enemy_scene: PackedScene
@export var m_scene : Node3D
@export var spawn_interval: float = 1.0  # Time in seconds between spawns
@export var max_enemies: int = 10  # Maximum number of enemies to spawn
@export var m_player : Node3D
@export var m_camera : Marker3D
@onready var myTimer = $Timer
var num_enemies: int = 0  # Counter for the current number of enemies

func _ready():
	# Load the enemy scene from the given path
	enemy_scene = load(enemy_scene_path)
	if not enemy_scene:
		push_error("Failed to load enemy scene from path: " + enemy_scene_path)
		return  # Stop further execution if the scene cannot be loaded
	# Start the spawn timer
	myTimer.wait_time = spawn_interval
	pass


func _on_timer_timeout():
	# Check if we can spawn another enemy
	if not m_scene :
		pass
	if m_scene.numEnemies < max_enemies:
		var enemy_instance = enemy_scene.instantiate()
		enemy_instance.player = m_player
		enemy_instance.camera = m_camera
		enemy_instance.scene = m_scene
		enemy_instance.is_init = true
		# Set the position of the enemy instance here (e.g., randomly within a range)
		enemy_instance.global_transform.origin = get_random_spawn_position()
		add_child(enemy_instance)
		m_scene.numEnemies += 1
		# Optionally, connect a signal from the enemy to know when it's been defeated/removed
		#enemy_instance.connect("defeated", self, "_on_senemy_defeated")
	pass

func get_random_spawn_position() -> Vector3:
	# Implement logic here to determine where the enemy should spawn
	return Vector3()

func _on_enemy_defeated():
	num_enemies -= 1
