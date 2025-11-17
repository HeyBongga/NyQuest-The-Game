extends Node

@export var world : Node
@export var dialogScene : Control

#Tiles und Index
var tile_scenes : Array = []
var tile_index : int = 1

#Signalobjekte
var interactables : Array = []

func _ready():
	var island_root = world.get_node("islandRoot")
	print("islandRoot =", island_root)
	
	#var island_root = world.get_node("islandRoot")
	
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

func on_object_clicked(object):
	match object.objectType:
		"house":
			handle_house_clicked()
		"windrad":
			handle_windrad_clicked()
		_:
			print("Unbekannter Objekt-Typ:", object.objectType)

func handle_house_clicked():
	var _dialogLines : Array[String] = [
	"Hallo",
	"Du Trottel",
	"LERN ENDLICH WAS EINE FREQUENZ IST",
	"oder Exmatrikulier dich",
	]
	
	dialogScene.visibility()
	dialogScene.dialogWindow.display_text("Tschau Kakao")


func handle_windrad_clicked():
	get_tree().change_scene_to_file("res://Scenes/cloudBackground.tscn")

func spawn_next_tile():
	if tile_index >= tile_scenes.size():
		return  # keine weiteren Tiles
	else:
		var tile = tile_scenes[tile_index]
		tile.visible = true
		animate_tile(tile)
		tile_index += 1

func animate_tile(tile):
	var tween = create_tween()
	tile.modulate.a = 0.0
	tween.tween_property(tile, "modulate:a", 1.0, 1.0)
