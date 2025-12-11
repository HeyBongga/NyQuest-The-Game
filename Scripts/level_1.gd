extends Node2D

var current_windmill_index = 0
var progress = 0
const MAX_PROGRESS = 5

@onready var loadingScreen = $LoadingScreen
@onready var windmills = $Windraeder.get_children()
@onready var checks = $UI/CheckContainer.get_children()
@onready var feedback_rect = $UI/Feedback
@onready var DialogScene = $DialogScene
@onready var Windrad1Pfeil1 = $Windraeder/Windrad1/Pfeil
@onready var Windrad1Pfeil2 = $Windraeder/Windrad1/Pfeil2
@onready var Windrad2Pfeil1 = $Windraeder/Windrad2/Pfeil
@onready var Windrad2Pfeil2 = $Windraeder/Windrad2/Pfeil2
@onready var Windrad3Pfeil1 = $Windraeder/Windrad3/Pfeil
@onready var Windrad3Pfeil2 = $Windraeder/Windrad3/Pfeil2
@onready var CameraVision = $UI/Button


var _dialogLineslevel1 : Array[String] = [
	"Schön du hast hierhergefunden,\nfür eine optimale Energieversorgung \nmüssen die Windräder richtig eingestellt sein...",
	"das erreicht man, indem man zum richtigen\nZeitpunkt die Windräder abtastet!\n Insgesamt brauche ich 5 hintereinander\n saubere Abtastungen...\n",
	"Als Hilfe kannst du dich an den Pfeilen oberhalb \nder Windräder orientieren.\nDenkst du, du schaffst das?"
	]
var _dialogLines2level1 : Array[String] = [
	"Niemand hat behauptet es wäre schwer :D\nund du hast es trotzdem geschafft!\nDas nenn ich Durchaltevermögen\nSpaß beiseite...",
	"Nun da du weißt wie sich ein Windrad dreht :D\nschauen wir uns mal das Ganze\naus der Sicht der DIGITALEN WELT an\ndu hast sicherlich keine Lust\nden ganzen Tag auf einer Wiese zu stehen...",
	"Das nennt sich heutzutage work life balance\n oder so...",
	"Probiere das Ganze nochmal, aber diesmal \nschau wie das ganze in der Kamera aussieht!"
	]
	
	

func _ready():
	loadingScreen.show_level_text()
	Windrad1Pfeil1.visible = false
	Windrad1Pfeil2.visible = false
	Windrad2Pfeil1.visible = false
	Windrad2Pfeil2.visible = false
	Windrad3Pfeil1.visible = false
	Windrad3Pfeil2.visible = false
	loadingScreen.finished_loading.connect(_on_loading_finished)
	DialogScene.finished_dialog.connect(_on_dialog_finished)
	
	reset_checks()
	feedback_rect.visible = false
	
func _on_loading_finished():
  # Erst wenn LoadingScreen fertig ist, Dialog starten
	DialogScene.show_dialog(_dialogLineslevel1)
	

	
func _on_dialog_finished():
	activate_windmill(0)
	#Windrad1Pfeil1.visible = true
	#Windrad1Pfeil2.visible = true
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and current_windmill_index < windmills.size():
		var wm = windmills[current_windmill_index]
		if wm.can_check():
			handle_correct()
		else:
			handle_wrong()

func handle_correct():
	progress += 1
	update_checks()
	if progress >= MAX_PROGRESS:
		go_to_next_windmill()

func handle_wrong():
	progress = 0
	reset_checks()
	show_error_flash()

func update_checks():
	for i in range(MAX_PROGRESS):
		checks[i].button_pressed = i < progress

func reset_checks():
	for check in checks:
		check.button_pressed = false

func go_to_next_windmill():
	windmills[current_windmill_index].set_active_state(false) 
	current_windmill_index += 1

	if current_windmill_index >= windmills.size():
		print("Level Completed!")
		DialogScene.show_dialog(_dialogLines2level1)
		DialogScene.finished_dialog2.connect(next_lines)
		return
	else:
		activate_windmill(current_windmill_index)
		reset_checks()
		progress = 0


func next_lines():
		current_windmill_index = 0
		activate_windmill(0)
		reset_checks()
		var tween = create_tween()
		CameraVision.visible = true
		tween.tween_property(CameraVision, "modulate:a", 0, 0) # 0 Sekunde ausblenden
		await tween.finished
		
		var tween2 = create_tween()
		tween2.tween_property(CameraVision, "modulate:a", 1, 1.0) # 1 Sekunde einblenden
		await tween2.finished
	
func activate_windmill(idx):
	for i in range(windmills.size()):
		windmills[i].set_active_state(i == idx)

func show_error_flash():
	feedback_rect.color = Color(1.0, 0.368, 0.3, 0.35)  
	feedback_rect.visible = true
	feedback_rect.modulate = Color.WHITE
	
	var tween = create_tween()
	tween.tween_property(feedback_rect, "modulate:a", 0.0, 0.3)
	tween.connect("finished", func(): feedback_rect.visible = false)
