extends Node

@onready var text_Window = preload("res://Scenes/dialog_window.tscn")
@onready var dialog_label: Label = null

var dialog_lines: Array[String] = []
var current_line_index = 0

var is_dialog_active = false
var can_advance_line = false

var dialogWindow : Control
var text

func set_label(lable : Label):
	dialog_label = lable
	
func set_window(setWindow : Control):
	dialogWindow = setWindow
	
func start_dialog(lines: Array[String]):
	dialogWindow.visibility()
	if is_dialog_active:
		return
	
	dialog_lines = lines
	current_line_index = 0
	is_dialog_active = true
	show_line()

func show_line():
	text = text_Window.instantiate()
	text.finished_displaying.connect(on_text_finished_displaying)
	text.display_text(dialog_lines[current_line_index])

func on_text_finished_displaying():
	can_advance_line = true

func _unhandled_input(event):
	if event.is_action_pressed("click_left_mouse") and is_dialog_active and can_advance_line:
		text.queue_free()
		current_line_index += 1
	if current_line_index >= dialog_lines.size():
		is_dialog_active = false
		current_line_index = 0
		return
	show_line()
