extends Camera2D

func focus_on_island(island_root: Node2D):
	if island_root.get_child_count() == 0:
		return

	# Bounding Box starten mit erstem Inselteil
	var first_child := island_root.get_child(0)
	var bbox = Rect2(first_child.position, Vector2.ZERO)

	# Alle Inselteile abtasten
	for child in island_root.get_children():
		bbox = bbox.expand_to(child.position)

	# Mittelpunkt finden
	var center = bbox.get_center()

	# Kamera animiert zur neuen Mitte bewegen
	var tween = create_tween()
	tween.tween_property(self, "position", center, 0.8).set_ease(Tween.EASE_OUT)
