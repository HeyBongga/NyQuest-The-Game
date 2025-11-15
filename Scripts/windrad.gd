extends Area2D

signal windrad_clicked

@onready var sprite := $Sprite2D
var zoom_scale := Vector2(1.2, 1.2)  # Zielgröße beim Hover

func _ready():
	print("House ready – warte auf Input")

func _on_mouse_entered():
	print("Maus ist über House!")
	sprite.scale = zoom_scale

func _on_mouse_exited():
	print("Maus hat House verlassen!")
	sprite.scale = Vector2.ONE

func _on_input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int):
	print("Input erkannt:", event)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("House wurde angeklickt!")
		emit_signal("windrad_clicked")
		$CollisionShape2D.disabled=true
