extends Control


func _on_in_game_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options.tscn")
