extends Node

var tile_scenes = []
var tile_index = 1
var house
var windrad1
var windrad2
var windrad3
var windrad4

func _ready():
	call_deferred("_setup_after_scene_loaded")
	
func _setup_after_scene_loaded():
	var current_scene = get_tree().get_current_scene()
	if current_scene == null:
		push_error("Keine aktuelle Szene gefunden!")
		return

	var island_root = current_scene.get_node_or_null("islandRoot")
	if island_root == null:
		push_error("islandRoot wurde noch nicht instanziert!")
		return
	
	print("island_root gefunden:", island_root)
	print("Kinder von island_root:")
	
	for child in island_root.get_children():
		print(" - ", child.name)
	
	tile_scenes = [
		island_root.get_node("islandTile1"),
		island_root.get_node("islandTile2"),
		island_root.get_node("islandTile3"),
		island_root.get_node("islandTile4"),
		island_root.get_node("islandTile5"),
	]
	house = island_root.get_node("islandTile1/House")
	house.house_clicked.connect(_on_object_clicked)
	
	windrad1 = island_root.get_node("islandTile2/Windrad")
	windrad1.windrad_clicked.connect(_on_object_clicked)
	
	windrad2 = island_root.get_node("islandTile3/Windrad")
	windrad2.windrad_clicked.connect(_on_object_clicked)

	windrad3 = island_root.get_node("islandTile4/Windrad")
	windrad3.windrad_clicked.connect(_on_object_clicked)
	
	windrad4 = island_root.get_node("islandTile5/Windrad")
	windrad4.windrad_clicked.connect(_on_object_clicked)
	
	
	
func _on_object_clicked():
	var ui = get_node("../UI/questDialogue")
	ui.start_dialog("Willkommen! Löse diese Aufgabe...")
	ui.dialog_finished.connect(_on_dialog_finished)


func _on_dialog_finished():
	var ui = get_node("../UI/questDialogue")
	ui.dialog_finished.disconnect(_on_dialog_finished)
	spawn_next_tile()

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
