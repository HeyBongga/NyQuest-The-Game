extends Node

@onready var island_root = $"../islandRoot"
var tile_scenes = [
	preload("res://Scenes/island_tile_1.tscn"),
	preload("res://Scenes/island_tile_2.tscn"),
]
var tile_index = 0

func _ready():
	var house = island_root.get_node("islandTile1/House")
	house.quest_started.connect(_on_house_quest_started)

func _on_house_quest_started():
	var ui = get_node("../CanvasLayer/questDialogue")
	ui.start_dialog("Willkommen! Löse diese Aufgabe...")
	ui.quest_finished.connect(_on_quest_finished)


func _on_quest_finished():
	var ui = get_node("../CanvasLayer/questDialogue")
	ui.quest_finished.disconnect(_on_quest_finished)
	spawn_next_tile()

func spawn_next_tile():
	if tile_index >= tile_scenes.size():
		return  # keine weiteren Tiles
	var tile = tile_scenes[tile_index]
	tile.visible = true
	animate_tile(tile)
	tile_index += 1

func animate_tile(tile):
	var tween = create_tween()
	tile.modulate.a = 0.0
	tween.tween_property(tile, "modulate:a", 1.0, 1.0)
