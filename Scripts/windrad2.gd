extends Node2D

@onready var speed = 0.75
@onready var rotation_speed = 360*speed# Grad pro Sekunde

var is_active = false
var can_hit = false
var GameOn = false

@onready var rotor = $Rotor
@onready var marker_area = $Rotor/Marker/Area2D
@onready var arrow_area = $Pfeil/Area2D

@onready var pfeil_normal = $Pfeil
@onready var pfeil_highlight = $Pfeil2
@onready var marker_normal = $Rotor/Marker
@onready var marker_highlight = $Rotor/Marker2
@onready var Camera = $"../../UI/Button"
@onready var CollisionShape = $Rotor/Marker/Area2D/CollisionShape2D

func _ready():
	Camera.TURNOFF.connect(Vanish)
	Camera.GO.connect(Camera_is_On)
	Camera.TURNOFF.connect(Camera_is_Off)
	if is_active and GameOn == true:
		pfeil_normal.visible = true
		pfeil_highlight.visible = false
		marker_normal.visible = true
		marker_highlight.visible = false
	marker_area.connect("area_entered", Callable(self, "is_aligned"))
	marker_area.connect("area_exited", Callable(self, "is_not_aligned"))

func _process(delta):
	#if is_active:
		rotor.rotation_degrees += rotation_speed * delta


func is_aligned(area):
	if area == arrow_area and GameOn == true:
		pfeil_normal.visible = false
		pfeil_highlight.visible = true
		marker_normal.visible = false
		marker_highlight.visible = true
		can_hit = true

func is_not_aligned(area):
	if area == arrow_area and GameOn == true:
		pfeil_normal.visible = true
		pfeil_highlight.visible = false
		marker_normal.visible = true
		marker_highlight.visible = false
		can_hit = false

func can_check() -> bool:
	return can_hit

func set_active_state(active: bool):
	is_active = active
	if active:
		modulate = Color(1,1,1,1) 
		CollisionShape.disabled = false
	else:
		modulate = Color(1,1,1,0.4)
		pfeil_normal.visible = false
		pfeil_highlight.visible = false
		marker_normal.visible = false
		marker_highlight.visible = false
		CollisionShape.disabled = true

func Vanish():
	pfeil_normal.visible = false
	
func Camera_is_On():
	GameOn = true
	
	
func Camera_is_Off():
	GameOn = false
	pfeil_normal.visible = false
	pfeil_highlight.visible = false
	
