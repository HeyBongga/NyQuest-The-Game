extends Node

var first_boot = true
var tile_index = 0

signal level_done

func status():
	tile_index += 1

func sig_emitten():
	print("siggi")
	level_done.emit(self)
