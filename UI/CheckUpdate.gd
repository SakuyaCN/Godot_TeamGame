extends Node2D


var item_count = 0
var new_count = 0
var loader:ResourceInteractiveLoader

func _ready():
	set_process(false)
	#change_scene("res://UI/Game.tscn")

func change_scene(res):
	loader =  ResourceLoader.load_interactive(res)
	item_count = loader.get_stage_count()
	set_process(true)
	$Update/CanvasLayer/ColorRect/Label2.text = "正在载入新场景中..."

func _process(time):
	new_count = loader.get_stage()
	loader.poll()
	$Update/CanvasLayer/ColorRect/Label2.text = "正在载入新场景中...%s"%str(new_count % item_count)
	if loader.get_resource():
		set_process(false)
		loader.get_resource()
		get_tree().change_scene_to(loader.get_resource())
