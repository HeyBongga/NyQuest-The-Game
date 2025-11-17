extends MarginContainer

@onready var label = $NinePatchRect/Label
@onready var timer = $letterDisplayTimer

var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2

signal finished_displaying

func display_text(text_to_display: String):
	await ready
	text = text_to_display
	label.text = text_to_display
	display_letter()

func display_letter():
	label.text += text[letter_index]
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return
	match text[letter_index]:
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)


func _on_letter_display_timer_timeout():
	display_letter() # Replace with function body.
