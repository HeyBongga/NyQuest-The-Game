extends Node2D

@onready var speed = 2
@onready var rotation_speed = 360*speed# Grad pro Sekunde

var is_active = false
var can_hit = false

@onready var rotor = $Rotor
@onready var marker_area = $Rotor/Marker/Area2D
@onready var arrow_area = $Pfeil/Area2D

@onready var pfeil_normal = $Pfeil
@onready var pfeil_highlight = $Pfeil2

func _ready():
	pfeil_normal.visible = true
	pfeil_highlight.visible = false
	marker_area.connect("area_entered", Callable(self, "is_aligned"))
	marker_area.connect("area_exited", Callable(self, "is_not_aligned"))

func _process(delta):
	rotor.rotation_degrees += rotation_speed * delta


func is_aligned(area):
	if area == arrow_area:
		pfeil_normal.visible = false
		pfeil_highlight.visible = true
		can_hit = true

func is_not_aligned(area):
	if area == arrow_area:
		pfeil_normal.visible = true
		pfeil_highlight.visible = false
		can_hit = false

func can_check() -> bool:
	return can_hit

func set_active_state(active: bool):
	is_active = active
	if active:
		modulate = Color(1,1,1,1) 
	else:
		modulate = Color(1,1,1,0.4)
