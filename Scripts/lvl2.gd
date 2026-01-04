extends Node2D

@onready var loadingScreen = $LoadingScreen
@onready var DialogScene = $DialogScene
@onready var cam = $Camera2D

@onready var speed = 0.25
@onready var rotation_speed = 360 * speed

# === Farben ===
const COLOR_DEFAULT = Color(6.477, 0.0, 0.517) # rot/pink
const COLOR_HIT = Color(3.014, 0.626, 0.0)     # orange
const COLOR_LOCKED = Color(0.3, 1.0, 0.3)      # grün

# === States ===
var touching_marker := ""      # aktuell berührter Marker
var locked_markers := {
	"Marker1": false,
	"Marker2": false,
	"Marker3": false
}

# === Umdrehungs- / Fortschritts-Logik ===
var last_rotation := 0.0
var missed_rotations := 0

# === Dialog ===
var _dialogLineslevel1 : Array[String] = [
	"So sieht man sich wieder! Ich brauche\nwieder einmal deine Hilfe! Aber diesmal\nist es etwas...komplizierter...",
	"Die Windräder im richtigen Moment aufnehmen\nwar einfach für dich, ich weiß :)\nJetzt machst du das auch\nABER...",
	"Dieses Mal musst du gleichzeitig ein passendes\n Bild aufnehmen und auswerten.\n Die Auswertung der Bilder erfolgt, wenn\ndu alle Bilder gemacht hast...",
	"Du kannst erst Bilder schießen, wenn du die\nMarker alle aktiviert hast...",
	"Versuche 3 Bilder vom Windrad zu machen!\nAchte darauf, dass du das Bild dann schießt, wenn das\nleuchtende Rotorblatt auf der Höhe der jweiligen Marker ist...",
	"Die Kamera kann insgesamt 3 Bilder aufnehmen,\nwenn du glaubst deine Bilder sind gut\n gehe in deine Fotogalerie und werte sie aus\nEntweder sie sind gut, oder du musst sie nochmal machen...", 
	"Du kannst jederzeit, neue Bilder aufnehmen,\ndrücke einfach auf das Mülleimer Symbol,\naber es werden alle gelöscht...",
	"Viel Erfolg!"
]

func _ready():
	loadingScreen.show_level_text()
	$ScreenShotarea/Feedback.visible = false
	loadingScreen.finished_loading.connect(_on_loading_finished)

	$Videokamera.GO.connect(Camera_On)
	$Videokamera.TURNOFF.connect(Camera_Off)


func _on_loading_finished():
	DialogScene.show_dialog(_dialogLineslevel1)


# ================= CAMERA =================

func Camera_On():
	var tween = create_tween()
	
	for i in [1, 2, 3]:
		var marker = $Windrad1.get_node("Marker%d" % i)
		marker.visible = true
		marker.modulate = COLOR_DEFAULT
		marker.modulate.a = 0.0
		tween.tween_property(marker, "modulate:a", 1.0, 0.4 + i * 0.2)

	var glow_area = $Windrad1/Rotor/MarkerGlow/MarkerGlowArea
	glow_area.area_entered.connect(Allign_hit)
	glow_area.area_exited.connect(Allign_exit)


func Camera_Off():
	var tween = create_tween()

	for i in [1, 2, 3]:
		var marker = $Windrad1.get_node("Marker%d" % i)
		tween.tween_property(marker, "modulate:a", 0.0, 0.4)
		tween.finished.connect(func(): marker.visible = false)


# ================= AREA LOGIC =================

func Allign_hit(area):
	var marker_name = _area_to_marker(area.name)
	if marker_name == "":
		return

	touching_marker = marker_name

	if not locked_markers[marker_name]:
		$Windrad1.get_node(marker_name).modulate = COLOR_HIT


func Allign_exit(area):
	var marker_name = _area_to_marker(area.name)
	if marker_name == "":
		return

	if touching_marker == marker_name:
		touching_marker = ""

	if not locked_markers[marker_name]:
		$Windrad1.get_node(marker_name).modulate = COLOR_DEFAULT


# ================= INPUT =================

func _input(event):
	if event.is_action_pressed("ui_accept") and touching_marker != "":
		locked_markers[touching_marker] = true
		$Windrad1.get_node(touching_marker).modulate = COLOR_LOCKED
		missed_rotations = 0   # Fortschritts-Reset zurücksetzen
		# Wenn jetzt alle Marker grün sind
		if _all_markers_locked():
			$ScreenShotarea/Kamera.visible = true  # Kamera erscheint

# ================= HELPER =================

func _area_to_marker(area_name: String) -> String:
	match area_name:
		"MarkerArea1": return "Marker1"
		"MarkerArea2": return "Marker2"
		"MarkerArea3": return "Marker3"
		_: return ""


# ================= UPDATE / ROTOR =================

func _process(delta):
	var rotor = $Windrad1/Rotor
	rotor.rotation_degrees += rotation_speed * delta

	# Prüfen, ob volle Umdrehung
	if rotor.rotation_degrees >= last_rotation + 360:
		last_rotation += 200
		_on_full_rotation()


# ================= ROTOR UMDREHUNGEN =================

func _on_full_rotation():
	# Prüfen: existiert irgendein grüner Marker?
	if _has_any_unlocked_marker():
		missed_rotations += 1
	else:
		missed_rotations = 0

	# Nach x verpassten Umdrehungen → alles zurücksetzen
	if missed_rotations >= 4:
		$ScreenShotarea/Kamera.visible = false
		_reset_progress()


func _has_any_unlocked_marker() -> bool:
	for key in locked_markers.keys():
		if locked_markers[key]:
			return true
	return false


func _reset_progress():
	missed_rotations = 0

	for key in locked_markers.keys():
		locked_markers[key] = false
		$Windrad1.get_node(key).modulate = COLOR_DEFAULT

func _all_markers_locked() -> bool:
	for key in locked_markers.keys():
		if not locked_markers[key]:
			return false
	return true
