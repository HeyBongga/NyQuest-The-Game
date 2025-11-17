extends Node

signal Game_ready

func _ready():
	# sendet ein Signal, dass die Szene fertig aufgebaut ist
	if GameState.first_boot:
		await get_tree().process_frame
		get_tree().change_scene_to_file("res://Scenes/mainMenu.tscn")
		GameState.first_boot = false
		emit_signal("Game_ready")
	else:
		emit_signal("Game_ready")
