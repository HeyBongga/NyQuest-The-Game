extends Control


func _on_startbutton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/mainScene.tscn")

func _on_quitbutton_pressed() -> void:
	get_tree().quit()
