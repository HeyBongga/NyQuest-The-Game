extends Control

@onready var  Screenshot1 = $Screenshot1
@onready var Screenshot2 = $Screenshot2
@onready var Screenshot3 = $Screenshot3
@onready var FotoOrdner = $FotoOrdner


var timer_active := false
var time := 0.0
var seconds := 0

func _process(delta):
	if timer_active:
		time += delta
		seconds = int(fmod(time, 60))
		$Seconds.text = "%02d" % seconds

# Wird vom Button (pressed()) aufgerufen
func Toggle_Timer():
	timer_active = not timer_active  # an/aus schalten
	if not timer_active:
		#Optional: Timer zurücksetzen
		time = 0
		seconds = 0
		$Seconds.text = "%02d" % seconds
		pass





func take_screenshot():
	# komplettes aktuelles bild
	visible = false
	var img = get_viewport().get_texture().get_image()
	
	# gloabaler Bereich vom Rechteck
	var rect = Screenshot1.get_global_rect()
	
	# zuschneiden
	var cropped = img.get_region(Rect2i(rect.position,rect.size))
	cropped.save_png("user://wildername.png")
	$Feedback.color = Color(1.0, 0.368, 0.3, 0.35)  
	$Feedback.visible = true
	$Feedback.modulate = Color.WHITE
	
	var tween = create_tween()
	tween.tween_property($Feedback, "modulate:a", 0.0, 0.3)
	tween.connect("finished", func(): $Feedback.visible = false)
	#await get_tree().create_timer(2.0,true).timeout
	#load_screenshot()
	visible = true
	
func load_screenshot():
	var img2 = Image.load_from_file("user://wildername.png")
	var tex = ImageTexture.create_from_image(img2)
	$image.texture = tex
