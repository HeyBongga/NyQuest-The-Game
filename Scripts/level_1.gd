extends Node2D

var current_windmill_index = 0
var progress = 0
const MAX_PROGRESS = 5
var GameplayReady  = false

@onready var loadingScreen = $LoadingScreen
@onready var windmills = $Windraeder.get_children()
@onready var checks = $UI/CheckContainer.get_children()
@onready var feedback_rect = $UI/Feedback
@onready var DialogScene = $DialogScene
@onready var CameraVision = $UI/Button
@onready var Frequenz1 = $UI/ColorRect
@onready var Frequenz2 = $UI/ColorRect2
@onready var Frequenz3 = $UI/ColorRect3
@onready var modulate1 = $Windraeder/Windrad1
@onready var modulate2 = $Windraeder/Windrad2
@onready var modulate3 = $Windraeder/Windrad3


var _dialogLineslevel1 : Array[String] = [
	"Schön du hast hierhergefunden,\nfür eine optimale Energieversorgung \nmüssen die Windräder richtig eingestellt sein...",
	"das erreicht man, indem man zum richtigen\nZeitpunkt die Windräder aufnimmt!\n Insgesamt brauche ich 5 hintereinander\n saubere Aufnahmen...\n",
	"Als Hilfe kannst du die Kamera Vision \nverwenden und das richtige Timing finden.\nDenkst du, du schaffst das?"
	]
var _dialogLines2level1 : Array[String] = [
	"Niemand hat behauptet es wäre schwer :D\nund du hast es trotzdem geschafft!\nDas nenn ich Durchaltevermögen\nSpaß beiseite...",
	"Nun da du dich an die Kameraansicht gewöhnt\n hast schauen wir uns mal an\nwas für Ergebnisse wir für unsere\nWindräder haben...",
	"Die Kamera liefert uns die Umdrehungen\npro Sekunde in Hertz oder Hz..."
	]
	
	

func _ready():
	loadingScreen.show_level_text()
	CameraVision.GO.connect(Camera_is_On)
	CameraVision.TURNOFF.connect(Camera_is_Off)
	loadingScreen.finished_loading.connect(_on_loading_finished)
	DialogScene.finished_dialog.connect(_on_dialog_finished)
	reset_checks()
	feedback_rect.visible = false
	
func _on_loading_finished():
  # Erst wenn LoadingScreen fertig ist, Dialog starten
	DialogScene.show_dialog(_dialogLineslevel1)
	
func _on_dialog_finished():
	activate_windmill(0)
	var tween = create_tween()
	CameraVision.visible = true
	tween.tween_property(CameraVision, "modulate:a", 0, 0) # 0 Sekunde ausblenden
	await tween.finished
		
	var tween2 = create_tween()
	tween2.tween_property(CameraVision, "modulate:a", 1, 1.0) # 1 Sekunde einblenden
	await tween2.finished
	
		
		
		
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and current_windmill_index < windmills.size() and GameplayReady == true:
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
		DialogScene.finished_dialog.connect(show_Hertz)
		return
	else:
		activate_windmill(current_windmill_index)
		reset_checks()
		progress = 0


func show_Hertz():
	
	for i in range(windmills.size()):
		windmills[i].set_active_state(false)
	Frequenz1.visible = true
	Frequenz2.visible = true
	Frequenz3.visible = true
	modulate1 = Color(1,1,1,1) 
	modulate2 = Color(1,1,1,1) 
	modulate3 = Color(1,1,1,1) 
	
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
	
func Camera_is_On():
	GameplayReady = true
	
func Camera_is_Off():
	GameplayReady = false
	
	
