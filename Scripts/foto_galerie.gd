extends Control

@onready var image1 = $ScreenshotArea
@onready var image2 = $ScreenshotArea2
@onready var image3 = $ScreenshotArea3
@onready var image4 = $ScreenshotArea4
@onready var DialogScene = $DialogScene
@onready var NeueBilder = $Notizblock/Kriterienliste/NeueBilder
@onready var Szenenwechsel = 0

@onready var zoom_target = $Camera2D/Marker2D
@onready var zoom_target2 = $Camera2D/Marker2D2
@onready var zoom_target3 = $Camera2D/Marker2D3
@onready var cam = $Camera2D

@onready var sekunden_spinbox = $Einsteller/Sekunden
@onready var wert_label = $Diagram/RichTextLabel

# Pfade der Screenshots
var screenshot_paths := [
	"user://screenshot_1.png",
	"user://screenshot_2.png",
	"user://screenshot_3.png",
	"user://screenshot_4.png"
]

var _dialogLinesFotogalerie : Array[String] = [
	"Hier sind wir in der Fotogalerie, jetzt schauen\nwir uns die Bilder an und du kannst sagen,\nob du sie behalten willst oder neue\nschießen möchtest...",
	"Als Hilfestellung für die Bilderauswahl habe ich\ndir eine Kriterienliste zusammengestellt, die dir\nhelfen soll..."
]

var _dialogLinesFotogalerie2 : Array[String] = [
	"Du bist also zufrieden mit den Bilder\nSuper! Lass sie und auswerten!\nGebe den Zeitpunkt der Messung und die\n Stellung des Rotoblatts in Grad ein...",
	"Verwende die DegreeLens als Hilfe!\nSchließe die Textbox und\nKlicke auf das erste Bild!"
]

var _dialogLinesFotogalerie3 : Array[String] = [
	"Hoffentlich hast du brauchbare Werte,\ndann schauen wir mal, ob sie was taugen\nhierfür tragen wir die Werte in ein Diagramm ein\n",
	
	]

func is_ready():
	if $".".visible == true and Szenenwechsel == 0:
		load_first_screenshots()
		DialogScene.show_dialog(_dialogLinesFotogalerie)
		Szenenwechsel += 1
	else:
		print("huhu")
		load_first_screenshots()

func load_first_screenshots():
	var images = [image1, image2, image3, image4]  # Array mit den ImageViews
	for i in range(4):
		var path = "user://screenshot_%d.png" % (i + 1)
		if !FileAccess.file_exists(path):
			continue  # überspringt, wenn Screenshot nicht existiert
		var img = Image.load_from_file(path)
		var tex = ImageTexture.create_from_image(img)
		images[i].texture = tex  # hier wird das richtige Image gesetzt

func Bilder_Lassen():
	$ScreenshotArea/Zoom_In.disabled = false
	$Notizblock/Kriterienliste.visible = false
	DialogScene.show_dialog(_dialogLinesFotogalerie2)
	$Notizblock.visible = false
	var tween_fader = create_tween()
	$Einsteller.visible = true
	$Einsteller.modulate.a = 0.0
	tween_fader.tween_property($Einsteller, "modulate:a", 1.0, 0.4)
	Spawn_Evaluator()

func New_Pics():
	for path in screenshot_paths:
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(path)
	$Notizblock/Kriterienliste.visible = false
	$".".visible = false

func Spawn_Evaluator():
	print("", $Einsteller/Sekunden.value)


func start_zoom():
	$Einsteller/GoToNextPic.disabled = false
	$Einsteller/GoToNextPic2.disabled = false
	$ScreenshotArea/Zoom_In.disabled = true
	var tween := create_tween()

	tween.tween_property(
		cam,
		"global_position",
		zoom_target.global_position,
		2
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.parallel().tween_property(
		cam,
		"zoom",
		Vector2(2, 2),
		1.2
	)
	
func Open_Degree():
	$Einsteller/DegreeLens1/Degree.visible = true
	$Einsteller/DegreeLens1.disabled = true
	
func Open_Degree2():
	$Einsteller/DegreeLens2/Degree.visible = true
	$Einsteller/DegreeLens2.disabled = true
	
func Open_Degree3():
	$Einsteller/DegreeLens3/Degree.visible = true
	$Einsteller/DegreeLens3.disabled = true
	
func Open_Degree4():
	$Einsteller/DegreeLens4/Degree.visible = true
	$Einsteller/DegreeLens4.disabled = true
	
	
func Next_Pic():
	$Einsteller/GoToNextPic.visible = false
	var tween := create_tween()

	tween.tween_property(
		cam,
		"global_position",
		zoom_target2.global_position,
		2
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.parallel().tween_property(
		cam,
		"zoom",
		Vector2(2, 2),
		1.2
	)

func Zoom_out():
	var Daten = [
		$Einsteller/Sekunden,
		$Einsteller/Grad,
		$Einsteller/Sekunden2,
		$Einsteller/Grad2,
		$Einsteller/Sekunden3,
		$Einsteller/Grad3,
		$Einsteller/Sekunden4,
		$Einsteller/Grad4
	]
	$Einsteller/GoToNextPic2.visible = false
	var tween := create_tween()

	tween.tween_property(
		cam,
		"global_position",
		zoom_target3.global_position,
		1
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.parallel().tween_property(
		cam,
		"zoom",
		Vector2(1, 1),
		1.2
	)
	await get_tree().create_timer(2).timeout
	DialogScene.show_dialog(_dialogLinesFotogalerie3)
	await get_tree().create_timer(2).timeout
	$Diagram.visible = true
	
	print("",$Einsteller/Sekunden.value)
	print("",$Einsteller/Sekunden2.value)
	print("",$Einsteller/Sekunden3.value)
	print("",$Einsteller/Grad4.value)
	#Convert()
	


func Convert():
	$Einsteller.visible = false
	#await get_tree().create_timer(2).timeout
	sekunden_spinbox.value_changed.connect(_on_sekunden_changed)
	_on_sekunden_changed(sekunden_spinbox.value)

func _on_sekunden_changed(value):
	wert_label.text = str(value)
