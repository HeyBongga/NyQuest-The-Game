extends Node2D
# oder Node2D, je nachdem, woran dein Sprite hängt

# Rotationsgeschwindigkeit in Grad pro Sekunde
@export var rotation_speed1: float = 180.0
@export var rotation_speed2: float = 90.0
@export var rotation_speed3: float = 120.0

func _process(delta: float) -> void:
	# Sprite rotiert kontinuierlich im Uhrzeigersinn
	$Windrad1/WindradLevel.rotation_degrees += rotation_speed1 * delta
	$Windrad2/WindradLevel.rotation_degrees += rotation_speed2 * delta
	$Windrad3/WindradLevel.rotation_degrees += rotation_speed3 * delta

func is_intersecting():
	pass
