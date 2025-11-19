extends Area2D

@export var objectType := "windrad"

signal clicked(this_object)

@onready var animatedSprite := $AnimatedSprite2D


var zoom_scale := Vector2(1.2, 1.2)  # Zielgröße beim Hover

func _ready():
	print("Windrad ready – warte auf Input")
	animatedSprite.play("Windrad_idle")

func on_mouse_entered():
	animatedSprite.scale = zoom_scale

func on_mouse_exited():
	animatedSprite.scale = Vector2.ONE

func on_input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int):
	if event.is_action_pressed("click_left_mouse"):
		clicked.emit(self)
		$CollisionShape2D.disabled=true
