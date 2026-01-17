extends Node2D

func _ready() -> void:
	self.visible = false
	if GameState.construction_ready:
		$New_Zeichen.show()
		$New_Zeichen/Zeichen/AnimationPlayer.play("Zeichen_Bounce")
