extends Node

@export var world : Node
@export var dialogScene : Control

#Tiles und Index
var tile_scenes : Array = []
#Signalobjekte
var interactables : Array = []

func _enter_tree():
	print("GameManager CONNECT")
	GameState.level_finished.connect(_on_level_finished)
	if GameState.finished_levels.has("Level1"):
		_on_level_finished("Level1")
	dialogScene.finished_dialog.connect(spawn_next_tile)
	
func _exit_tree():
	if GameState.level_finished.is_connected(_on_level_finished):
		GameState.level_finished.disconnect(_on_level_finished)


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


func _on_level_finished(level_name):
	await ready
	print("GameManager RECEIVED:", level_name)
	spawn_next_tile()

func on_object_clicked(object):
	match object.objectType:
		"house":
			handle_house_clicked()
			GameState.tile_index += 1
		"windrad":
			handle_windrad_clicked()
		"labor":
			handle_labor_clicked()
		_:
			print("Unbekannter Objekt-Typ:", object.objectType)

func handle_house_clicked():
	var _dialogLines : Array[String] = [
	"Willkommen auf Nyquest! \nGut, dass du da bist...",
	"Hier gibt es eine Menge zu tun \nund wir brauchen dringend deine Hilfe...",
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
		var tile = tile_scenes[GameState.tile_index]
		tile.visible = true
		animate_tile(tile)
		GameState.tile_index += 1

func animate_tile(tile):
	var tween = create_tween()
	tile.modulate.a = 0.0
	tween.tween_property(tile, "modulate:a", 1.0, 1.0)
