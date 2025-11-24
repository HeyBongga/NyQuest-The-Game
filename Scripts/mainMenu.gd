extends Control


func _on_startbutton_pressed() -> void:
	self.visible = false
	$"../../World".visible = true
	$"../inGameUI".visible = true

func _on_quitbutton_pressed() -> void:
	get_tree().quit()
