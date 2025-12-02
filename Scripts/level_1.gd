extends Node2D

var current_windmill_index = 0
var progress = 0
const MAX_PROGRESS = 5

@onready var loadingScreen = $LoadingScreen
@onready var windmills = $Windraeder.get_children()
@onready var checks = $UI/CheckContainer.get_children()
@onready var feedback_rect = $UI/Feedback

func _ready():
	loadingScreen.show_level_text()
	activate_windmill(0)
	reset_checks()
	feedback_rect.visible = false

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
		return
	else:
		activate_windmill(current_windmill_index)
		reset_checks()
		progress = 0

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
