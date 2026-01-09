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

# Spinboxen zur Einstellung der Zeiten und Gradzahlen
@onready var sekunden_spinbox = $Einsteller/Sekunden
@onready var sekunden_spinbox2 = $Einsteller/Sekunden2
@onready var sekunden_spinbox3 = $Einsteller/Sekunden3
@onready var sekunden_spinbox4 = $Einsteller/Sekunden4

@onready var grad_spinbox = $Einsteller/Grad
@onready var grad_spinbox2 = $Einsteller/Grad2 
@onready var grad_spinbox3 = $Einsteller/Grad3
@onready var grad_spinbox4 = $Einsteller/Grad4

# Signal für convert wird immer getriggerd wenn Dialog finished ist deshalb convert zur überprüfung
var converterino = 0
var the_cross_of_holy_might = 0

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
var perfect_measure = 0


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
	DialogScene.finished_dialog.connect(Convert)



func Convert():
	print("ich war hier")
	if converterino == 0:
		$Diagram.visible = true
		$Einsteller.visible = false
		
		sekunden_spinbox.value_changed.connect(_on_sekunden_changed)
		sekunden_spinbox2.value_changed.connect(_on_sekunden_changed2)
		sekunden_spinbox3.value_changed.connect(_on_sekunden_changed3)
		sekunden_spinbox4.value_changed.connect(_on_sekunden_changed4)
		
		grad_spinbox.value_changed.connect(_on_grad_changed)
		grad_spinbox2.value_changed.connect(_on_grad_changed2)
		grad_spinbox2.value_changed.connect(_on_grad_changed3)
		grad_spinbox2.value_changed.connect(_on_grad_changed4)
		
		_on_sekunden_changed(sekunden_spinbox.value)
		_on_sekunden_changed2(sekunden_spinbox2.value)
		_on_sekunden_changed3(sekunden_spinbox3.value)
		_on_sekunden_changed4(sekunden_spinbox4.value)
		
		_on_grad_changed(grad_spinbox.value)
		_on_grad_changed2(grad_spinbox2.value)
		_on_grad_changed3(grad_spinbox3.value)
		_on_grad_changed4(grad_spinbox4.value)
		converterino += 1
		get_distance()
		await get_tree().create_timer(10).timeout
		move_Diagram()
		await get_tree().create_timer(2).timeout
		#if perfect_measure >= 3:
			#DialogScene.show_dialog(_dialogLinesFotogalerie5)
			#DialogScene.finished_dialog.connect(ending)
		#else:
		DialogScene.show_dialog(_dialogLinesFotogalerie4)
		var the_key = 0
		the_key += 1
		if the_key == 1:
			DialogScene.finished_dialog.connect(TheHolyMight360_0)
			DialogScene.finished_dialog.connect(ending)
				
			
			
	elif converterino ==	1:
		return
	
	
	
# Konvertierung von Spinbox value zu text im Graphen
func _on_sekunden_changed(value):
	Zeitpunkt1.text = str(value)
func _on_sekunden_changed2(value):
	Zeitpunkt2.text = str(value)
func _on_sekunden_changed3(value):
	Zeitpunkt3.text = str(value)
func _on_sekunden_changed4(value):
	Zeitpunkt4.text = str(value)
	
func _on_grad_changed(value):
	var Verschiebung = 0
	Grad1.text = str(value)
	if value < 270 and value > 90:
		if value < 270 and value > 180:
			Verschiebung = 270 - value  
			Grad1.position += Vector2(0,Verschiebung+15)
			$Diagram/Punkt1.position += Vector2(0,Verschiebung)
		else:
			Verschiebung = value - 90  
			Grad1.position += Vector2(0,Verschiebung+15)
			$Diagram/Punkt1.position += Vector2(0,Verschiebung)
	else:
		if value == 360:
			Grad1.position += Vector2(0,-90-15)
			$Diagram/Punkt1.position += Vector2(0,-90)
		elif value >= 270:
			Verschiebung = value - 270
			Grad1.position += Vector2(0,-Verschiebung+15)
			$Diagram/Punkt1.position += Vector2(0,-Verschiebung)
	if value < 90:
		Verschiebung = 90 - value
		Grad1.position += Vector2(0,-Verschiebung-15)
		$Diagram/Punkt1.position += Vector2(0,-Verschiebung)
		
func _on_grad_changed2(value):
	var Verschiebung2 = 0
	Grad2.text = str(value)
	
	if value < 270 and value > 90:
		if value < 270 and value > 180:
			Verschiebung2 = 270 - value  
			Grad2.position += Vector2(0,Verschiebung2+15)
			$Diagram/Punkt2.position += Vector2(0,Verschiebung2)
		else:
			Verschiebung2 = value - 90  
			Grad2.position += Vector2(0,Verschiebung2+15)
			$Diagram/Punkt2.position += Vector2(0,Verschiebung2)
	else:
		if value == 360:
			Grad2.position += Vector2(0,-90-15)
			$Diagram/Punkt2.position += Vector2(0,-90)
		elif value >= 270:
			Verschiebung2 = value - 270
			Grad2.position += Vector2(0,-Verschiebung2+15)
			$Diagram/Punkt2.position += Vector2(0,-Verschiebung2)
	if value < 90:
		Verschiebung2 = 90 - value
		Grad2.position += Vector2(0,-Verschiebung2-15)
		$Diagram/Punkt2.position += Vector2(0,-Verschiebung2)	
			
func _on_grad_changed3(value):
	var Verschiebung3 = 0
	Grad3.text = str(value)
	if value < 270 and value > 90:
		if value < 270 and value > 180:
			Verschiebung3 = 270 - value  
			Grad3.position += Vector2(0,Verschiebung3+15)
			$Diagram/Punkt3.position += Vector2(0,Verschiebung3)
		else:
			Verschiebung3 = value - 90  
			Grad3.position += Vector2(0,Verschiebung3+15)
			$Diagram/Punkt3.position += Vector2(0,Verschiebung3)
	else:
		if value == 360:
			Grad3.position += Vector2(0,-90-15)
			$Diagram/Punkt3.position += Vector2(0,-90-15)
		elif value >= 270:
			Verschiebung3 = value - 270
			Grad3.position += Vector2(0,-Verschiebung3+15)
			$Diagram/Punkt3.position += Vector2(0,-Verschiebung3)
	if value < 90:
		Verschiebung3 = 90 - value
		Grad3.position += Vector2(0,-Verschiebung3-15)	
		$Diagram/Punkt3.position += Vector2(0,-Verschiebung3)
			
func _on_grad_changed4(value):
	var Verschiebung4 = 0
	Grad4.text = str(value)
	if value < 270 and value > 90:
		if value < 270 and value > 180:
			Verschiebung4 = 270 - value  
			Grad4.position += Vector2(0,Verschiebung4+15)
			$Diagram/Punkt4.position += Vector2(0,Verschiebung4)
		else:
			Verschiebung4 = value - 90  
			Grad4.position += Vector2(0,Verschiebung4+15)
			$Diagram/Punkt4.position += Vector2(0,Verschiebung4)
	else:
		if value == 360:
			Grad4.position += Vector2(0,-90-15)
			$Diagram/Punkt4.position += Vector2(0,-90)
		elif value >= 270:
			Verschiebung4 = value - 270
			Grad4.position += Vector2(0,-Verschiebung4+15)
			$Diagram/Punkt4.position += Vector2(0,-Verschiebung4)
	if value < 90:
		Verschiebung4 = 90 - value
		Grad4.position += Vector2(0,-Verschiebung4-15)
		$Diagram/Punkt4.position += Vector2(0,-Verschiebung4)


func get_distance():
	
	var distance_0_to_45 = abs($Einsteller/Grad.value-$Einsteller/Grad2.value)
	print(distance_0_to_45)
	var distance_45_to_90 = abs($Einsteller/Grad2.value-$Einsteller/Grad3.value)
	print(distance_45_to_90)
	var distance_180_to_270 = abs($Einsteller/Grad3.value-$Einsteller/Grad4.value)
	print(distance_180_to_270)
	var distance_270_to_360 = abs($Einsteller/Grad4.value-$Einsteller/Grad.value)
	print(distance_270_to_360)
	
	if distance_0_to_45 > 85 and distance_0_to_45 <95:
		perfect_measure += 1
		print("1 ",perfect_measure)
	else:
		perfect_measure -= 1
		print("1! ",perfect_measure)
	if distance_45_to_90 > 85 and distance_45_to_90 <95:
		perfect_measure += 1
		print("2 ",perfect_measure)
	else:
		perfect_measure -= 1
		print("2! ",perfect_measure)
	if distance_180_to_270 > 85 and distance_180_to_270 < 95:
		perfect_measure +=1
		print("3 ",perfect_measure)
	else:
		perfect_measure = 0
		print("3 ",perfect_measure)
	if distance_270_to_360 > 85 and distance_270_to_360 < 95:
		perfect_measure +=1
		print("4 ",perfect_measure)
	else:
		perfect_measure -= 1
		print("4! ",perfect_measure)
	
	print("in welcher welt",perfect_measure)
	
func move_Diagram():
	var tween := create_tween()
	tween.tween_property(
		$Diagram,
		"position",
		$Diagram.position + Vector2(0, -261),
		0.4
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func TheHolyMight360_0():
	if the_cross_of_holy_might == 0:
		print("the mighty came once")
		var Data = [
		$Einsteller/Grad.value,
		$Einsteller/Grad2.value,
		$Einsteller/Grad3.value,
		$Einsteller/Grad4.value
		]

		var min_value = Data[0]
		var winner = 0


		for i in range(1, 4):  # bis 4, weil range-Endwert exklusiv
				# Abstand zu 0/360 berechnen, Float-kompatibel mit fmod
			var distance_min = min(abs(fmod(min_value, 360)), abs(360 - fmod(min_value, 360)))
			var distance_i = min(abs(fmod(Data[i], 360)), abs(360 - fmod(Data[i], 360)))

			if distance_i < distance_min:
					min_value = Data[i]
					winner = i
			

			print("Neuer Gewinner:", min_value)
			
		var node_name = "Punkt" + str(winner + 1)  # +1 weil deine Nodes Punkt1..Punkt4 heißen
		#	var node_name2 = "Grad" + str(winner + 1)  # +1 weil deine Nodes Punkt1..Punkt4 heißen

		$Diagram/Grad1.visible = false
		$Diagram/Grad2.visible = false
		$Diagram/Grad3.visible = false
		$Diagram/Grad4.visible = false
		print(min_value)
		
		
	
		
		if winner == 3:
				var tween2 := create_tween()
				tween2.tween_property(
				$Diagram/Punkt3,
				"position",
				 Vector2(469,152),
				 2.2
			).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			
				var tween3 := create_tween()
				tween3.tween_property(
				$Diagram/Punkt2,
				"position",
				 Vector2(357,236),
				 1.8
			).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				
				var tween4 := create_tween()
				tween4.tween_property(
				$Diagram/Punkt1,
				"position",
				 Vector2(248,153),
				 1.4
			).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				
				var tween44 := create_tween()
				tween44.tween_property(
				$Diagram/Punkt4,
				"position",
				 Vector2(581,66),
				 1.4
			).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			

		if winner == 2:
				var tween5 := create_tween()
				tween5.tween_property(
				$Diagram/Punkt4,
				"position",
				 Vector2(581,152),
				 2.2
			).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			
				var tween6 := create_tween()
				tween6.tween_property(
				$Diagram/Punkt2,
				"position",
				 Vector2(357,152),
				 1.8
			).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				
				var tween7 := create_tween()
				tween7.tween_property(
				$Diagram/Punkt1,
				"position",
				 Vector2(248,236),
				 1.4
			).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				
				var tween77 := create_tween()
				tween77.tween_property(
				$Diagram/Punkt3,
				"position",
				 Vector2(469,66),
				 1.4
			).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				


		if winner == 1:
				var tween8 := create_tween()
				tween8.tween_property(
				$Diagram/Punkt4,
				"position",
				 Vector2(581,236),
				 2.2
			).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			
				var tween9 := create_tween()
				tween9.tween_property(
				$Diagram/Punkt3,
				"position",
				 Vector2(469,152),
				 1.8
			).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				
				var tween10 := create_tween()
				tween10.tween_property(
				$Diagram/Punkt1,
				"position",
				 Vector2(248,236),
				 1.4
			).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			
				var tween78 := create_tween()
				tween78.tween_property(
				$Diagram/Punkt3,
				"position",
				 Vector2(357,66),
				 1.4
			).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				
		if winner == 0:
				var tween11 := create_tween()
				tween11.tween_property(
				$Diagram/Punkt4,
				"position",
				 Vector2(581,152),
				 2.2
			).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			
				var tween12 := create_tween()
				tween12.tween_property(
				$Diagram/Punkt2,
				"position",
				 Vector2(357,152),
				 1.8
			).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				
				var tween13 := create_tween()
				tween13.tween_property(
				$Diagram/Punkt3,
				"position",
				 Vector2(469,236),
				 1.4
			).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
		
				var tween133 := create_tween()
				tween133.tween_property(
				$Diagram/Punkt1,
				"position",
				 Vector2(248,66),
				 1.4
			).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				
		the_cross_of_holy_might += 1
	else:
		return
func ending():
	if the_cross_of_holy_might == 1:
		print(the_cross_of_holy_might)
		DialogScene.show_dialog(_dialogLinesFotogalerie7)
		the_cross_of_holy_might += 1
		await get_tree().create_timer(30).timeout
		get_tree().change_scene_to_file("res://Scenes/credits.tscn")
		
		
	else:
		return
	
