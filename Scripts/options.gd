extends Node2D

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_beenden_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
# Called when the node enters the scene tree for the first time.
