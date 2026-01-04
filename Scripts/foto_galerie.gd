extends Control

@onready var image1 = $ScreenshotArea
@onready var image2 = $ScreenshotArea2
@onready var image3 = $ScreenshotArea3

func _ready():
	load_first_screenshots()


func load_first_screenshots():
	var images = [image1, image2, image3]  # Array mit den ImageViews

	for i in range(3):
		var path = "user://screenshot_%d.png" % (i + 1)
		if !FileAccess.file_exists(path):
			continue  # überspringt, wenn Screenshot nicht existiert
		var img = Image.load_from_file(path)
		var tex = ImageTexture.create_from_image(img)
		images[i].texture = tex  # hier wird das richtige Image gesetzt
