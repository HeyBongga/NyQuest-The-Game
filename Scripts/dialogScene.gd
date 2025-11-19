extends Control

@export var button : Button
@export var dialogWindow : MarginContainer

#signal dialog_finished

func _ready():
	visible = false
	button.visible = false
	
	#Signal verbinden
	dialogWindow.finished_all_lines.connect(finish_dialog)
	button.pressed.connect(on_button_pressed)

func show_dialog():
	visible = true
	button.visible = false  # Button erst später anzeigen

# Wird aufgerufen, wenn der Dialog *komplett* fertig ist
func finish_dialog():
	button.visible = true  # Jetzt darf man schließen drücken

		

func on_button_pressed() -> void:
	visible = false		# ganze Szene verstecken
	button.visible = false
	#dialog_finished.emit()
