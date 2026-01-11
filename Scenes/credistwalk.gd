extends TextureRect


func _ready():
	# Tween erstellen
	var tween = create_tween()

	# Tween-Eigenschaften einstellen: Node = self, Property = "position", Ziel = Vector2, Dauer = 1.5s
	tween.tween_property(self, "position", Vector2(0, -3650), 30).set_trans(Tween.TRANS_SINE)  # Transition-Typ.set_ease(Tween.EASE_OUT)     # Ease-Typ
