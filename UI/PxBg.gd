extends Node2D

var light_seed = 1
var is_run = true
# Called when the node enters the scene tree for the first time.
func _ready():
	$pre.visible = true
	pass # Replace with function body.

func _process(delta):
	if is_run:
		$pb1.scroll_offset.x -= delta * 50
		$pb2.scroll_offset.x -= delta * 40
		$pb3.scroll_offset.x -= delta * 30
		$pb4.scroll_offset.x -= delta * 20
	#get_parent().light.material.set_shader_param("seed",light_seed)
	#print(light_seed)
