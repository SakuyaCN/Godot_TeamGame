extends Node2D


var item_count = 0
var new_count = 0
var loader:ResourceInteractiveLoader

var sign_string = "8C:F9:DA:18:8A:30:3D:A1:2C:27:CA:1E:06:E1:53:38:5F:1C:63:52"

func _ready():
	set_process(false)
	if Engine.has_singleton("GodotUtils"):
		var singleton = Engine.get_singleton("GodotUtils")
		singleton.connect("onSignStringResult",self,"onSignStringResult")
		singleton.getSignString()
	elif OS.get_name() != "Android":
		change_scene("res://UI/Game.tscn")
	else:
		$Update/CanvasLayer/ColorRect/Label2.text = "签名不正确，请安卓正版软件"

func onSignStringResult(_sign_string):
	if _sign_string == sign_string:
		change_scene("res://UI/Game.tscn")
	else:
		$Update/CanvasLayer/ColorRect/Label2.text = "签名不正确，请安卓正版软件"

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
