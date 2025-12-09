extends TextureButton

@onready var camera_overlay = $AnimatedSprite2D
@onready var camera_filter1 = $AnimatedSprite2D/ColorRect
@onready var camera_filter2 = $AnimatedSprite2D/ColorRect2
@onready var camera_filter3 = $AnimatedSprite2D/ColorRect3

func _ready():
	pressed.connect(_on_cameraButton_pressed)
	camera_overlay.visible = false
	camera_overlay.modulate.a = 0.0

func _on_cameraButton_pressed():
	if camera_overlay.visible == false:
		fade_camera_on()
	else:
		fade_camera_off()

func fade_camera_on():
	var tween = create_tween()
	camera_overlay.visible = true
	camera_overlay.play("Camera_on")
	camera_overlay.modulate.a = 0.0
	tween.tween_property(camera_overlay, "modulate:a", 1, 1)

func fade_camera_off():
	var tween = create_tween()
	tween.tween_property(camera_overlay, "modulate:a", 0.0, 0.4)
	tween.finished.connect(func(): camera_overlay.visible = false)
