extends Area2D

@export var objectType := "windrad"
signal clicked(this_object)

@onready var sprite := $Sprite2D
var zoom_scale := Vector2(1.2, 1.2)  # Zielgröße beim Hover

func _ready():
	print("Windrad ready – warte auf Input")

func on_mouse_entered():
	sprite.scale = zoom_scale

func on_mouse_exited():
	sprite.scale = Vector2.ONE

func on_input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int):
	if event.is_action_pressed("click_left_mouse"):
		clicked.emit(self)
		$CollisionShape2D.disabled=true
