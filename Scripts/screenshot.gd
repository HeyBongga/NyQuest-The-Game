extends Control

# Bereiche, die fotografiert werden
@onready var Screenshot1 = $Screenshot1
@onready var FotoOrdner = $FotoOrdner   # (später für Galerie)
@onready var SzenenWechsel = 0




# Timer
var timer_active := false
var time := 0.0
var seconds := 0

# Screenshot-Logik
var screenshot_index := 1          # zählt von 1–4
const MAX_SCREENSHOTS := 4
var screenshot_paths := []          # merkt sich die Pfade

# -------------------------
# TIMER
# -------------------------
func _process(delta):
	if timer_active:
		time += delta
		seconds = int(fmod(time, 60))
		$Seconds.text = "%02d" % seconds

# Wird vom Kamera-Button aufgerufen
func Toggle_Timer():
	timer_active = not timer_active

	# Timer ausschalten + zurücksetzen
	if not timer_active:
		time = 0
		seconds = 0
		$Seconds.text = "%02d" % seconds

# -------------------------
# SCREENSHOT
# -------------------------
func take_screenshot():
	# UI ausblenden, damit es nicht im Bild ist
	visible = false

	# Aktuelles Bild vom Viewport holen
	var img = get_viewport().get_texture().get_image()

	# Bereich definieren (hier Screenshot1)
	var rect = Screenshot1.get_global_rect()

	# Bild zuschneiden
	var cropped = img.get_region(Rect2i(rect.position, rect.size))

	# Pfad erzeugen (user:// = Laufzeitordner)
	var path = "user://screenshot_%d.png" % screenshot_index

	# Bild speichern
	cropped.save_png(path)

	# Pfad merken
	screenshot_paths.append(path)
	

	# Kurzes visuelles Feedback
	$Feedback.visible = true
	$Feedback.modulate = Color.WHITE
	var tween = create_tween()
	tween.tween_property($Feedback, "modulate:a", 0.0, 0.3)
	tween.finished.connect(func(): $Feedback.visible = false)

	# UI wieder anzeigen
	visible = true
	if screenshot_index == MAX_SCREENSHOTS:
		$FotoOrdner.visible = true
		$Kamera.disabled = true
		return
	screenshot_index += 1
	

# -------------------------
# LETZTES BILD LADEN (optional)
# -------------------------
func load_last_screenshot():
	if SzenenWechsel > 0:
		$"../FotoGalerie".visible = true
		$FotoOrdner.visible = false
	if screenshot_paths.is_empty():
		return
	$"../FotoGalerie".visible = true
	$FotoOrdner.visible = false

func delete_photos():
	$Kamera.disabled = false
	$FotoOrdner.visible = false
	screenshot_index = 1
	
