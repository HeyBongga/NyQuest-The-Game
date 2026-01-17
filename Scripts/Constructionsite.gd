extends Area2D

@export var objectType := "construction"

signal clicked(this_object)

var zoom_scale := Vector2(2.25, 2.25)  # Zielgröße beim Hover

func _ready():
	if GameState.labor_ready:
		print("lconstruction ready – warte auf Input")

func on_mouse_entered():
	if GameState.construction_ready:
		$Sprite2D.scale = zoom_scale

func on_mouse_exited():
	if GameState.construction_ready:
		$Sprite2D.scale = Vector2(1.75, 1.75)

func on_input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int):
	if event.is_action_pressed("click_left_mouse"):
		clicked.emit(self)
		$CollisionShape2D.disabled = true
		$"../New_Zeichen".hide()
		GameState.construction_ready = false
