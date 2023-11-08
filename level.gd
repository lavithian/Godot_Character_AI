extends Node3D
@export var bullet: Area3D

var myrot: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	myrot = Vector3.ZERO
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

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



