extends CanvasLayer


func show_level_text():
	var label = $ColorRect

	# Fade in
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 1.0) # 1 Sekunde einblenden
	await tween.finished

	# 1.5 Sekunden stehen lassen
	await get_tree().create_timer(1.0).timeout

	# Fade out
	var tween2 = create_tween()
	tween2.tween_property(label, "modulate:a", 0.0, 1.0) # 1 Sekunde ausblenden
	await tween2.finished
