extends Node3D
@export var bullet: Area3D
@export var player : CharacterBody3D
@export var ui : Control
@export var materials : Resource
#@export var start_menu : Control
var myrot: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	myrot = Vector3.ZERO
	$Screens/StartMenu.queue_free()
	print(materials)
	print(materials.lumber)
	print(materials.stone)
	# Stops the restart menu
	# $Screens/RestartMenu.set_process_input(false)
	pass

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

func _on_podrick_health_changed(current_health, max_health):
	ui.get_child(0).get_child(0).value = current_health
	pass


func _on_podrick_gain_lumber(amount):
	materials.gain_lumber(amount)
	ui.get_child(0).get_child(1).text = "Lumber: " + str(materials.lumber)
	pass # Replace with function body.


func _on_podrick_gain_stone(amount):
	materials.gain_stone(amount)
	ui.get_child(0).get_child(2).text = "Stone: " + str(materials.stone)
	pass # Replace with function body.
