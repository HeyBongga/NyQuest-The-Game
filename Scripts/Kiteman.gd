extends PathFollow2D

@export var speed: float = 150.0
var previous_x: float

func _ready():
	loop = true               # Path wiederholt sich automatisch
	previous_x = global_position.x

func _process(delta):
	progress += speed * delta

	# flip_h, wenn Richtung sich ändert
	var current_x = global_position.x

	if current_x > previous_x:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false

	previous_x = current_x
