extends Control

func _ready() -> void:
	$VBoxContainer/Play.grab_focus()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://level.tscn")
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
