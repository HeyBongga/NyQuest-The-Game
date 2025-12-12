extends Node2D

@onready var speed = 0.5
@onready var rotation_speed = 360*speed# Grad pro 2 Sekunden

signal Modulate

var is_active = false
var can_hit = false
var GameplayReady = false
var Modulatet = false

@onready var rotor = $Rotor
@onready var marker_area = $Rotor/Marker/Area2D
@onready var arrow_area = $Pfeil/Area2D

@onready var pfeil_normal = $Pfeil
@onready var pfeil_highlight = $Pfeil2
@onready var marker_normal = $Rotor/Marker
@onready var marker_highlight = $Rotor/Marker2
@onready var CameraVision = $"../../UI/Button"

func _ready():
	CameraVision.GO.connect(Camera_is_On)
	CameraVision.TURNOFF.connect(visibility)
	CameraVision.TURNOFF.connect(Camera_is_Off)
	if is_active and GameplayReady == true:
		pfeil_normal.visible = true
		pfeil_highlight.visible = false
		marker_normal.visible = true
		marker_highlight.visible = false
	marker_area.connect("area_entered", Callable(self, "is_aligned"))
	marker_area.connect("area_exited", Callable(self, "is_not_aligned"))

func _process(delta):
	if is_active: 
		rotor.rotation_degrees += rotation_speed * delta


func is_aligned(area):
	if area == arrow_area and GameplayReady == true:
		pfeil_normal.visible = false
		pfeil_highlight.visible = true
		marker_normal.visible = false
		marker_highlight.visible = true
		can_hit = true
	

func is_not_aligned(area):
	if area == arrow_area and GameplayReady == true:
		pfeil_normal.visible = true
		pfeil_highlight.visible = false
		marker_normal.visible = true
		marker_highlight.visible = false
		can_hit = false
	

func visibility():
	pfeil_normal.visible = false
	pfeil_highlight.visible = false
	

func can_check() -> bool:
	return can_hit

func set_active_state(active: bool):
	is_active = active
	if active:
		modulate = Color(1,1,1,1) 
	else:
		modulate = Color(1,1,1,0.4)
		pfeil_normal.visible = false
		pfeil_highlight.visible = false
		marker_normal.visible = false
		marker_highlight.visible = false
		Modulate.emit()
		Modulate.connect(TurnOff)
		
func Camera_is_On():
	GameplayReady = true
	if Modulatet == true: 
		pfeil_normal.visible = false
	else:
		pfeil_normal.visible = true

func Camera_is_Off():
	GameplayReady = false
	

func TurnOff():
	Modulatet = true
	pfeil_normal.visible = false
	pfeil_highlight.visible = false
