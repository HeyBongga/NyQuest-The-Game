extends TextureButton


@onready var ClearButton = $"."

# Pfade der Screenshots
var screenshot_paths := [
	"user://screenshot_1.png",
	"user://screenshot_2.png",
	"user://screenshot_3.png",
	"user://screenshot_4.png"
]

func _ready():
	ClearButton.pressed.connect(_on_clear_button_pressed)

func _on_clear_button_pressed():
	# Alle Screenshots löschen
	for path in screenshot_paths:
			if FileAccess.file_exists(path):
				DirAccess.remove_absolute(path)
