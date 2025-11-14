extends MarginContainer

# Referenzen zu den Buttons
@onready var toggle_menu_button = $ToggleContainer/togglemenubutton
@onready var options_button = $PopupContainer/OptionsContainer/optionsbutton
@onready var quit_button = $PopupContainer/QuitContainer/quitbutton

var menu_visible = false  # Merkt sich, ob Menü gerade offen ist

func _ready():
	# Menü-Buttons beim Start ausblenden
	options_button.visible = false
	quit_button.visible = false

	# Signal verbinden
	# toggle_menu_button.pressed.connect(_on_togglemenubutton_pressed)

func _on_togglemenubutton_pressed():
	# Sichtbarkeit umschalten
	menu_visible = !menu_visible

	options_button.visible = menu_visible
	quit_button.visible = menu_visible

func _on_optionsbutton_pressed():
	get_tree().change_scene_to_file("res://Scenes/options.tscn")
	
	
	
func _on_quitbutton_pressed() -> void:
	get_tree().quit()

#@export var toggle_screen: MarginContainer
#@export var popup_screen: MarginContainer
#
#func toggle_visibility(object):
	#if object.visible:
		#object.visible = false
	#else:
		#object.visible = true
#
#
#func _on_togglemenubutton_pressed():
	#toggle_visibility(toggle_screen)
	#toggle_visibility(popup_screen)
