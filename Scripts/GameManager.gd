extends Node

@export var world : Node
@export var dialogScene : Control

#Tiles und Index
var tile_scenes : Array = []
#Signalobjekte
var interactables : Array = []

func _enter_tree():
	GameState.level_done.connect(spawn_next_tile)
	dialogScene.finished_dialog.connect(spawn_next_tile)

func _ready():
	var island_root = world.get_node("islandRoot")
	print("islandRoot =", island_root)
	
	# Alle Tiles automatisch sammeln...
	for islandTile in island_root.get_children(): # islandTile1 bis islandTile5
		tile_scenes.append(islandTile)
	
	# Interaktives Objekt im Tile suchen...
	for child in island_root.get_children():
		
		if child.name.begins_with("islandTile"):
			for object in child.get_children():
				if object.has_signal("clicked"):
					object.clicked.connect(on_object_clicked)
					interactables.append(object)
	
	for i in range(GameState.tile_index+1):
		tile_scenes[i].visible = true
		print(i)
	
	

func on_object_clicked(object):
	match object.objectType:
		"house":
			handle_house_clicked()
		"windrad":
			handle_windrad_clicked()
		"labor":
			handle_labor_clicked()
		_:
			print("Unbekannter Objekt-Typ:", object.objectType)

func handle_house_clicked():
	var _dialogLines : Array[String] = [
	"Willkommen auf Nyquest! \nGut, dass du da bist...",
	"Hier gibt es eine Menge zutun \nund wir brauchen dringend deine Hilfe...",
	"Erkunde einfach mal die Insel \nund schaue wo dein Wissen von Nöten ist...",
	"Ich bin übriegens Sigfried Signal, aber du \nkannst mich Sigi nennen. Bis zum nächsten Mal!",
	]
	
	dialogScene.show_dialog(_dialogLines)

func handle_windrad_clicked():
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")

func handle_labor_clicked():
	get_tree().change_scene_to_file("res://Scenes/lvl2.tscn")

func spawn_next_tile():
	if GameState.tile_index > tile_scenes.size():
		print("nope")
		return  # keine weiteren Tiles
	else:
		print("JOPE")
		var tile = tile_scenes[GameState.tile_index+1]
		tile.visible = true
		animate_tile(tile)


func animate_tile(tile):
	var tween = create_tween()
	tile.modulate.a = 0.0
	tween.tween_property(tile, "modulate:a", 1.0, 1.0)
