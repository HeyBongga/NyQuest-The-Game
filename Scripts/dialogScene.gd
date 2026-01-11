extends Control

@export var button : Button
@export var dialogWindow : MarginContainer
@onready var Sigfried_Signal = $DialogChar

@onready var dialog_lines : Array[String]

signal finished_dialog
#signal finished_dialog2 # für level 1 nach erster Abtastung



func _ready():
	visible = false
	button.visible = false
	#Signal verbinden
	dialogWindow.finished_all_lines.connect(finish_all_lines)
	button.pressed.connect(on_button_pressed)

func show_dialog(lines):
	dialogWindow.start_dialog(lines)
	visible = true
	button.visible = false  # Button erst später anzeigen

# Wird aufgerufen, wenn der Dialog *komplett* fertig ist
func finish_all_lines():
	button.visible = true  # Jetzt darf man schließen drücken

func on_button_pressed() -> void:
	self.visible = false # ganze Szene verstecken
	finished_dialog.emit()
	#finished_dialog2.emit()
