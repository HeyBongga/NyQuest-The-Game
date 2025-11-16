extends Camera2D

@export var zoomSpeed : float = 5
@export var minZoom : float = 0.5
@export var maxZoom : float = 2.5

var zoomTarget : Vector2
var dragStartMousePos = Vector2.ZERO
var dragStartCameraPos = Vector2.ZERO
var isDragging : bool = false

func _ready():
	zoomTarget = zoom
	pass

func _process(delta):
	Zoom(delta)
	ClickAndDrag()
	
func Zoom(delta):
	if Input.is_action_just_pressed("camera_zoom_in"):
		zoomTarget *= 1.25
	if Input.is_action_just_pressed("camera_zoom_out"):
		zoomTarget *= 0.75
	# --- Zoom limits (clamp) ---
	zoomTarget.x = clamp(zoomTarget.x, minZoom, maxZoom)
	zoomTarget.y = clamp(zoomTarget.y, minZoom, maxZoom)
	#zoom = zoomTarget
	zoom = zoom.lerp(zoomTarget, zoomSpeed * delta)

func get_visible_world_rect() -> Rect2:
	var screen_size = get_viewport_rect().size
	var half = screen_size * zoom * 0.5
	return Rect2(global_position - half, screen_size * zoom)


func ClickAndDrag():
	if !isDragging and Input.is_action_just_pressed("camera_move"):
		dragStartMousePos = get_viewport().get_mouse_position()
		dragStartCameraPos = position
		isDragging = true
		
	if isDragging and Input.is_action_just_released("camera_move"):
		isDragging = false
		
	if isDragging:
		var moveVector = get_viewport().get_mouse_position() - dragStartMousePos
		position = dragStartCameraPos - moveVector * 1/zoom.x
