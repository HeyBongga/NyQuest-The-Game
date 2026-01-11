extends Control

@onready var image1 = $ScreenshotArea
@onready var image2 = $ScreenshotArea2
@onready var image3 = $ScreenshotArea3
@onready var image4 = $ScreenshotArea4
@onready var DialogScene = $DialogScene
@onready var NeueBilder = $Notizblock/Kriterienliste/NeueBilder
@onready var Szenenwechsel = 0

@onready var zoom_target = $Camera2D/Marker2D
@onready var zoom_target2 = $Marker2D2
@onready var zoom_target3 = $Marker2D3
@onready var cam = $Camera2D

# Spinboxen zur Einstellung der Zeiten und Gradzahlen
@onready var sekunden_spinbox = $Einsteller/Sekunden
@onready var sekunden_spinbox2 = $Einsteller/Sekunden2
@onready var sekunden_spinbox3 = $Einsteller/Sekunden3
@onready var sekunden_spinbox4 = $Einsteller/Sekunden4

@onready var grad_spinbox = $Einsteller/Grad
@onready var grad_spinbox2 = $Einsteller/Grad2 
@onready var grad_spinbox3 = $Einsteller/Grad3
@onready var grad_spinbox4 = $Einsteller/Grad4


var Option_Selection1 = 0
var Option_Selection1_1 = 0
var Option_Selection2 = 0
var Option_Selection2_2 = 0
var Option_Selection3 = 0
var Option_Selection4 = 0

# Anzeige der Gradzahl und der Zeitpunkte für das Diagram
@onready var Grad1 = $Diagram/Grad1
@onready var Grad2 = $Diagram/Grad2
@onready var Grad3 = $Diagram/Grad3
@onready var Grad4 = $Diagram/Grad4
@onready var Zeitpunkt1 = $Diagram/Zeitpunkt1
@onready var Zeitpunkt2 = $Diagram/Zeitpunkt2
@onready var Zeitpunkt3 = $Diagram/Zeitpunkt3
@onready var Zeitpunkt4 = $Diagram/Zeitpunkt4

# für Dialog Auswahl
var opener = 0


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
	"Du bist also zufrieden mit den Bilder.\nSuper! Lass sie und auswerten!\nGebe den Zeitpunkt der Messung und die\n Stellung des Rotoblatts in Grad ein...",
	"Verwende die DegreeLens als Hilfe!\nSchließe die Textbox und\nKlicke auf das erste Bild!"
]

var _dialogLinesFotogalerie3 : Array[String] = [
	"Hoffentlich hast du brauchbare Werte,\ndann schauen wir mal, ob sie was taugen\nhierfür tragen wir die Werte in ein Diagramm ein\n",
	]
	
var _dialogLinesFotogalerie4 : Array[String] = [
	"Na das sieht ja mal... interessant aus\nIch mache nur einen letzten feinschliff\n..."
	]
var _dialogLinesFotogalerie5 : Array[String] = [
	"Hehey Nyquist himself, das sieht sehr gut aus.\nKommen dir diese Punkte irgendwie bekannt\nvor?\nFällt dir eine bestimmte Funktion ein,\nwenn du diese Punkte miteinander verbinden\nwürdest...",
	 "Stell es dir mal vor"
	]

var _dialogLinesFotogalerie6 : Array[String] = [
	 "Kommen dir diese Punkte irgendwie Bekannt vor?\n Fällt dir eine bestimmte Funktion ein,\nwenn du diese Punkte miteinander verbinden würdest? Stell es dir mal vor"
	]


var _dialogLinesFotogalerie7 : Array[String] = [
	"Kommen dir diese Punkte bekannt vor?\n Fällt dir eine bestimmte Funktion ein,\nwenn du diese Punkte miteinander verbindest?\nStell es dir mal vor...",
	"Genau so sehen periodische Signale aus.\nWenn du die Punkte weich verbindest,\nentsteht eine saubere Schwingung.\nSinus oder Cosinus – mehr braucht es\nim Grunde gar nicht...",
	"Und jetzt kommt der spannende Teil:\nJedes noch so komplizierte Signal\nlässt sich aus Sinus- und Cosinuswellen\nzusammensetzen.\nSignalverarbeitung ist im Kern\nnur cleveres Zerlegen und Zusammensetzen.",
	"Dahinter steckt am Anfang viel Mathematik,\naber lass dich davon nicht abschrecken\nSignalverarbeitung begegnet dir fast täglich,\nIn Musik, in Bildern, im Handy in deiner Tasche...",
	"Überall werden Signale gemessen, zerlegt und\nwieder zusammengesetzt,meist auf Basis\neinfacher Schwingungen.",
	"Dieses Mini-Spiel ist für all diejenigen, die\neinen falschen Eindruck von der\nSignalverarbeitung haben,\noder noch garnicht so genau wissen\nwas Signalverarbeitung eigentlich ist\n...",
	"Und wenn ihr erst jetzt einen schlechten \nEindruck bekommen habt...",
	"... G e r n g e s c h e h e n ♥️ "
]




func is_ready():
	if $".".visible == true and Szenenwechsel == 0:
		load_first_screenshots()
		DialogScene.show_dialog(_dialogLinesFotogalerie)
		Szenenwechsel += 1
	else:
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

func New_Pics():
	for path in screenshot_paths:
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(path)
	$Notizblock/Kriterienliste.visible = false
	$".".visible = false


func start_zoom():
	$Einsteller/GoToNextPic.disabled = false
	$Einsteller/GoToNextPic2.disabled = false
	$ScreenshotArea/Zoom_In.disabled = true
	var tween := create_tween()

	tween.tween_property(
		cam,
		"position",
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
		zoom_target2.position,
		2
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	

func Zoom_out():
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
	DialogScene.finished_dialog.connect(Show_Diagram)
	

func Show_Diagram():
	
	if opener == 0:
		var tween_fader = create_tween()
		$Diagram.visible = true
		$Diagram.modulate.a = 0.0
		tween_fader.tween_property($Diagram, "modulate:a", 1.0, 0.4)
			
		match $Einsteller/Grad.get_selected_id():
			
			1:
				$"Diagram/Gradzahl_1/360_0".visible = true
				Option_Selection1 += 1
			2:
				$"Diagram/Gradzahl_1/90_270".visible = true
				Option_Selection2 += 1
				
				
			3:
				$"Diagram/Gradzahl_1/180".visible = true
				Option_Selection3 += 1
			4:
				$"Diagram/Gradzahl_1/90_270".visible = true
				Option_Selection4 += 1
				
		
		match $Einsteller/Grad2.get_selected_id():
			1:
				$"Diagram/Gradzahl_2/360_0".visible = true
				Option_Selection4 += 1
				
			2:
				$"Diagram/Gradzahl_2/90_270".visible = true
				Option_Selection1_1 += 1
			3:
				$"Diagram/Gradzahl_2/180".visible = true
				Option_Selection2_2 += 1
				
			4:
				$"Diagram/Gradzahl_2/90_270".visible = true
				
		match $Einsteller/Grad3.get_selected_id():
			1:
				$"Diagram/Gradzahl_3/360_0".visible = true
			2:
				$"Diagram/Gradzahl_3/90_270".visible = true
			3:
				$"Diagram/Gradzahl_3/180".visible = true
			4:
				$"Diagram/Gradzahl_3/90_270".visible = true
		
		match $Einsteller/Grad4.get_selected_id():
			1:
				$"Diagram/Gradzahl_4/360_0".visible = true
			2:
				$"Diagram/Gradzahl_4/90_270".visible = true
			3:
				$"Diagram/Gradzahl_4/180".visible = true
			4:
				$"Diagram/Gradzahl_4/90_270".visible = true
			
		await get_tree().create_timer(2.5).timeout
		move_Diagram()	
		await get_tree().create_timer(5).timeout
		print(opener)
		opener += 1
		DialogScene.show_dialog(_dialogLinesFotogalerie5)
		DialogScene.finished_dialog.connect(Create_Wave)

func Create_Wave():
	print("ich war hier")
	if opener == 1:
		if Option_Selection1 + Option_Selection1_1 == 2:
			print("hola")
			var tween_fader = create_tween()
			$Diagram/Option3.visible = true
			$Diagram/Option3.modulate.a = 0.0
			tween_fader.tween_property($Diagram/Option3, "modulate:a", 1.0, 0.4)
		elif Option_Selection2 + Option_Selection2_2 == 2:
			var tween_fader = create_tween()
			$Diagram/Option2.visible = true
			$Diagram/Option2.modulate.a = 0.0
			tween_fader.tween_property($Diagram/Option2, "modulate:a", 1.0, 0.4)
		elif Option_Selection3 == 1:
			var tween_fader = create_tween()
			$Diagram/Option4.visible = true
			$Diagram/Option4.modulate.a = 0.0
			tween_fader.tween_property($Diagram/Option4, "modulate:a", 1.0, 0.4)
		elif  Option_Selection4 == 2:
			$Diagram/Option1.visible = true
	opener += 1	
		
func move_Diagram():
		var tween := create_tween()
		tween.tween_property(
			$Diagram,
			"position",
			$Diagram.position + Vector2(0, -261),
			0.4
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)



	
