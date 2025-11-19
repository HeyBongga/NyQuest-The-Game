extends Node2D

@export var cloud_speeds_background := {
	"cloud1": 20, 
	"cloud2": 30,
	"cloud3": 25,
	"cloud4": 15,
}

var screen_width := 0.0

func _ready():
	screen_width = get_viewport_rect().size.x

func _process(delta):
		for cloudname in cloud_speeds_background.keys():
			var cloud := $".".get_node(cloudname)
			cloud.position.x += cloud_speeds_background[cloudname] * delta
			var cloud_width = cloud.texture.get_width() * cloud.scale.x
			
			var right_limit = screen_width + cloud_width
			
			if cloud.position.x > right_limit:
				cloud.position.x = -cloud_width
