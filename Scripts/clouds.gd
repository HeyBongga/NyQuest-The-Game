extends Parallax2D

@export var cloud_speeds := {
	"cloud1": 30.0, 
	"cloud2": 40.0,
	"cloud3": 45.0,
	"cloud4": 35.0,
	"cloud5": 20.0,
	"cloud6": 50.0,
}

var screen_width := 0.0

func _ready():
	screen_width = get_viewport_rect().size.x


func _process(delta):
	for cloudname in cloud_speeds.keys():
		var cloud := $cloudLayerBackground.get_node(cloudname)
		cloud.position.x += cloud_speeds[cloudname] * delta
		var cloud_width = cloud.texture.get_width() * cloud.scale.x
		
		var right_limit = screen_width + cloud_width
		
		if cloud.position.x > right_limit:
			cloud.position.x = -cloud_width
