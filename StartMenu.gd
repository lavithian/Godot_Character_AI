extends Control

func _ready() -> void:
	$VBoxContainer/Play.grab_focus()
	pass

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://level.tscn")
	pass

func _on_exit_pressed() -> void:
	get_tree().quit()
	pass
