extends Node3D
@export var bullet: Area3D
@export var player : CharacterBody3D
@export var ui : Control
#@export var start_menu : Control
var myrot: Vector3
var numEnemies: int

# Called when the node enters the scene tree for the first time.
func _ready():
	numEnemies = 1
	myrot = Vector3.ZERO
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	pass

func instantiate_bullet(start_pos, start_dir) -> void :
	print("pew pew")
	if bullet:
		var bullet_instance = bullet.duplicate()
		add_child(bullet_instance)
		bullet_instance.global_transform.origin = start_pos
		bullet_instance.rotation = start_dir
		bullet_instance.initialize_velocity1(start_dir)
	else:
		push_error("bullet node unset")
	pass
	
func _on_player_health_changed(health, max_health):
	ui.get_child(0).get_child(0).value = health
	pass



