extends Area2D

@export var objectType := "windrad"

signal clicked(this_object)

@onready var animatedSprite := $Sprite2D/AnimatedSprite2D


var zoom_scale := Vector2(1.2, 1.2)  # Zielgröße beim Hover

func _ready():
	if GameState.windrad_ready:
		print("Windrad ready – warte auf Input")
	
	animatedSprite.play("Windrad_idle")

func on_mouse_entered():
	if GameState.windrad_ready:
		$Sprite2D.scale = zoom_scale

func on_mouse_exited():
	if GameState.windrad_ready:
		$Sprite2D.scale = Vector2.ONE

func on_input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int):
	if GameState.windrad_ready:
		if event.is_action_pressed("click_left_mouse"):
			clicked.emit(self)
			$CollisionShape2D.disabled=true
			GameState.windrad_ready = false
