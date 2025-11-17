extends Control

@export var button : Button

signal dialog_finished

func _ready() -> void:
	self.visible = false

func visibility():
	if visible:
		visible = false
	else:
		visible = true

func on_button_pressed() -> void:
	self.visible = false
	dialog_finished.emit()
