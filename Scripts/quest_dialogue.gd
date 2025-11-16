extends Control

signal dialog_done

func _ready():
	self.visible=false

func visibility():
	if visible:
		visible = false
	else:
		visible = true

func on_button_pressed():
	emit_signal("dialog_done")
