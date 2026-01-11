extends TextureButton


# Called when the node enters the scene tree for the first time.



func _on_pressed() -> void:
	$How_to_Play.visible = true


func _on_how_to_play_pressed() -> void:
	$How_to_Play.visible = false
