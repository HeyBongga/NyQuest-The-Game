extends Control

@export var button : Button
@export var dialogWindow : MarginContainer

signal dialog_finished

func _ready():
	self.visible = false

func visibility():
	if visible:
		visible = false
		
	else:
		visible = true
		

func on_button_pressed() -> void:
	self.visible = false
	dialog_finished.emit()
