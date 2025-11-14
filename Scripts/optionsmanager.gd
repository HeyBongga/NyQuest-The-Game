extends Control

func _on_start_pressed() -> void:
	pass
	

func _on_options_pressed() -> void:
	pass


func _on_zurueck_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/mainMenu.tscn")
