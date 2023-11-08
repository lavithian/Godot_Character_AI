extends Node3D

@export var player : CharacterBody3D
@export var ui : Control
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _on_player_health_changed(health, max_health):
	print(health)
	print(max_health)
	print(ui.get_child(0).get_child(0).value)
	ui.get_child(0).get_child(0).value = health
	pass # Replace with function body.
