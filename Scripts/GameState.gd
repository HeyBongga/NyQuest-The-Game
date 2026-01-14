extends Node

signal level_finished(level_name)

var finished_levels := {}

var first_boot = true
var tile_index = 0

var house_ready = true
var windrad_ready = true
var labor_ready = true
var construction_ready = true

func finish_level(level_name: String):
	print("GameState: Level finished:", level_name)
	finished_levels[level_name] = true
	level_finished.emit(level_name)
