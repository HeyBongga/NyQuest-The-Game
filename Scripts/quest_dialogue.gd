extends Control

signal dialog_finished

func _ready():
	self.visible=false

func start_dialog(text):
	$MarginContainer/MarginContainer/Label.text = text
	visible = true

func _on_button_pressed():
	visible = false
	emit_signal("dialog_finished")
