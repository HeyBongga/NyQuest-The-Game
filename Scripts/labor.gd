extends Area2D

@export var objectType := "labor"

signal clicked(this_object)

@onready var animatedSprite := $Sprite2D

var zoom_scale := Vector2(1, 1)  # Zielgröße beim Hover

func _ready():
	if GameState.labor_ready:
		print("labor ready – warte auf Input")
	$AnimatedSprite2D.play("Windrad_idle")

func on_mouse_entered():
	if GameState.labor_ready:
		animatedSprite.scale = zoom_scale

func on_mouse_exited():
	if GameState.labor_ready:
		animatedSprite.scale = Vector2(0.75, 0.75)

func on_input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int):
	if event.is_action_pressed("click_left_mouse"):
		clicked.emit(self)
		$CollisionPolygon2D.disabled = true
		GameState.labor_ready = false
