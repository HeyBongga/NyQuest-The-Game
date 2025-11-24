extends Control

func _ready():
	self.visible = false

func _on_levelbutton_pressed() -> void:
	pass

func _on_backbutton_pressed() -> void:
	self.visible = false
	$"../../World".visible = true
	$"../inGameUI".visible = true
	
