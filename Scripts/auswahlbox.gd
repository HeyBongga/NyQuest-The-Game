extends TextureRect


func handle_correct_answer():
	$"Auswahl/Auswahl_text/richtige Antwort".visible = true
	$Auswahl.disabled = true
	await get_tree().create_timer(10).timeout
	get_tree().change_scene_to_file("res://Scenes/mainScene.tscn")

func handle_wrong_answer():
	$"Auswahl2/Auswahl2_text/falsche Antwort".visible = true
	$Auswahl2.disabled = true

func handle_wrong_answer2():
	$"Auswahl3/Auswahl3_text/falsche Antwort".visible = true
	$Auswahl3.disabled = true
