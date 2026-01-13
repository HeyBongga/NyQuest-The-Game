extends Node2D

@onready var loadingScreen = $LoadingScreen
@onready var DialogScene = $DialogScene





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
	"Marker3": false,
	"Marker4": false
}

# === Umdrehungs- / Fortschritts-Logik ===
var last_rotation := 0.0
var missed_rotations := 0

# === Dialog ===
var _dialogLineslevel1 : Array[String] = [
"So sieht man sich wieder!\nDiesmal wartet eine\nschwierigere Aufgabe auf dich...",
"Zuerst musst du alle Marker aktivieren.\nErst danach erscheint eine Kamera...",
"Die Marker aktivierst du\nmit der 'Leertaste'...",
"Deine Aufgabe:\nMache g...",
"Schieße jedes Bild genau dann,\nwenn das leuchtende Rotorblatt\nauf der Höhe eines Markers ist...",
"Wichtig:\nJedes Bild muss einen\nanderen Marker treffen..",
"Die Kamera kann 4 Bilder speichern.\nDanach kannst du die Bilder\nin der Fotogalerie auswerten...",
"Du kannst Bilder jederzeit löschen\nund neu aufnehmen.\nDabei werden alle gelöscht...",
"Viel Erfolg!"
]

func _ready():
	$FotoGalerie.visible = false
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
	
	for i in [1, 2, 3, 4]:
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

	for i in [1, 2, 3, 4]:
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
		"MarkerArea4": return "Marker4"
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
	
