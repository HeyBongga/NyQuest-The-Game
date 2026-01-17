extends Node2D

func _ready() -> void:
	self.visible = false
	if GameState.labor_ready:
		$New_Zeichen.show()
		$New_Zeichen/Zeichen/AnimationPlayer.play("Zeichen_Bounce")
