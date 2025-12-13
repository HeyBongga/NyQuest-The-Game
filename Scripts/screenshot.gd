extends Control

@onready var  Screenshot1 = $Screenshot1
@onready var Screenshot2 = $Screenshot2
@onready var Screenshot3 = $Screenshot3

func take_screenshot():
	# komplettes aktuelles bild
	visible = false
	var img = get_viewport().get_texture().get_image()
	
	# gloabaler Bereich vom Rechteck
	var rect = Screenshot1.get_global_rect()
	
	# zuschneiden
	var cropped = img.get_region(Rect2i(rect.position,rect.size))
	cropped.save_png("res://Screenshots/screenshot.png")
	await get_tree().create_timer(2.0,true).timeout
	load_screenshot()
	visible = true
func load_screenshot():
	var img2 = Image.load_from_file("res://Screenshots/screenshot.png")
	var tex = ImageTexture.create_from_image(img2)
	$image.texture = tex
