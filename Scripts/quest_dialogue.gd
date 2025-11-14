extends Control

signal quest_finished

func start_dialog(text):
	$MarginContainer/MarginContainer/Label.text = text
	visible = true

func _on_button_pressed():
	visible = false
	emit_signal("quest_finished")
