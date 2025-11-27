extends Node2D

@export var camera : Camera2D
@export var cloud_speeds_foreground := {
	"cloud5": 40, 
	"cloud6": 45,
	"cloud7": 55,
	"cloud8": 50,
	"cloud9": 15,
	"cloud10": 15,
}
var screen_width := 0.0

func _ready():
	screen_width = get_viewport_rect().size.x

func _process(delta):
	for cloudname in cloud_speeds_foreground.keys():
			var cloud := $".".get_node(cloudname)
			cloud.position.x += cloud_speeds_foreground[cloudname] * delta
			var cloud_width = cloud.texture.get_width() * cloud.scale.x
			
			var right_limit = screen_width + cloud_width
			
			if cloud.position.x > right_limit:
				cloud.position.x = -cloud_width
