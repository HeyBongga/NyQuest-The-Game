extends MarginContainer

@export var textBox : NinePatchRect

@onready var label = $NinePatchRect/Label
@onready var timer = $letterDisplayTimer

var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2

signal finished_displaying

# -----------------------------
# Mehrzeilen-Variablen
# -----------------------------
var dialog_lines: Array[String] = []
var current_index: int = 0
var is_animating := false

# -----------------------------
# Dialog starten (Array übergeben)
# -----------------------------

func start_dialog(lines: Array[String]):
	dialog_lines = lines
	current_index = 0
	label.text = ""
	letter_index = 0
	is_animating = true
	display_text(dialog_lines[current_index])
	show()


# -----------------------------
# Einzelne Zeile anzeigen
# -----------------------------
func display_text(text_to_display: String):
	is_animating = true
	text = text_to_display
	label.text = ""
	letter_index = 0
	display_letter()
	
# -----------------------------
# Buchstabenweise anzeigen
# -----------------------------
func display_letter():
	label.text += text[letter_index]
	letter_index += 1
	
	if letter_index >= text.length():
		finished_displaying.emit()
		is_animating = false
		return
		
	match text[letter_index]:
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)

func _on_letter_display_timer_timeout():
	display_letter()

# -----------------------------
# Auf Weiter-Klick reagieren
# -----------------------------
func next_line():
	# Falls Text noch animiert → Sofort fertig anzeigen
	if is_animating:
		timer.stop()          # <-- Wichtig: Timer stoppen!
		label.text = text
		letter_index = text.length()
		is_animating = false
		return

	# Nächste Zeile
	current_index += 1

	# Gibt es noch Zeilen?
	if current_index < dialog_lines.size():
		display_text(dialog_lines[current_index])
	else:
		hide()

# -----------------------------
# Taste zum Weitermachen
# -----------------------------
func _input(event):
	# Tastendruck (z.B. Leertaste / Enter)
	if event.is_action_pressed("ui_accept"):
		next_line()
		
	elif event.is_action_pressed("click_left_mouse"):
		next_line()	
	
		
		
	
	
		
