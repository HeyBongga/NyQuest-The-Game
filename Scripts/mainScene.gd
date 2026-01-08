extends Node


func _ready():
	# sendet ein Signal, dass die Szene fertig aufgebaut ist
	if GameState.first_boot:
		$UI/mainMenu.visible = true
		$UI/inGameUI.visible = false
		$World.visible = false
		GameState.first_boot = false
	else:
		$UI/mainMenu.visible = false
		$UI/inGameUI.visible = true
		$World.visible = true
