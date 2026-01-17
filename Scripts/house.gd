extends Area2D

@export var objectType := "house"
signal clicked(this_object)

@onready var sprite := $Sprite2D
var zoom_scale := Vector2(1.2, 1.2)  # Zielgröße beim Hover

func _ready():
	if GameState.house_ready:
		print("House ready – warte auf Input")

func on_mouse_entered():
	if GameState.house_ready:
		sprite.scale = zoom_scale

func on_mouse_exited():
	if GameState.house_ready:
		sprite.scale = Vector2.ONE

func on_input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int):
	if GameState.house_ready:
		if event.is_action_pressed("click_left_mouse"):		
			clicked.emit(self)
			$CollisionShape2D.disabled=true
			$"../New_Zeichen".hide()
			GameState.house_ready = false
