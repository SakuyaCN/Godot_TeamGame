extends Node2D


var item_count = 0
var new_count = 0
var loader:ResourceInteractiveLoader
var is_sin_ok = false
var sign_string = "8C:F9:DA:18:8A:30:3D:A1:2C:27:CA:1E:06:E1:53:38:5F:1C:63:52"

func _ready():
	ConstantsValue.update = self
	set_process(false)
	if Engine.has_singleton("GodotUtils"):
		var singleton = Engine.get_singleton("GodotUtils")
		singleton.connect("onSignStringResult",self,"onSignStringResult")
		singleton.getSignString()
	elif OS.get_name() != "Android":
		start_check()
	else:
		$Update/CanvasLayer/ColorRect/Label2.text = "签名不正确，请安卓正版软件"

func onSignStringResult(_sign_string):
	if _sign_string == sign_string:
		start_check()
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

func start_check():
	var http = GodotHttp.new()
	http.connect("http_res",self,"on_http")
	http.connect("http_err",self,"on_error")
	var query = JSON.print({
		"uuid":OS.get_unique_id()
	})
	http.http_post("login/ban",query)

func on_http(url,data):
	if data["data"].ban:
		$Update/CanvasLayer/ColorRect/Label.text = "由于您使用作弊软件或发表不正当言论导致账号已被封禁！"
	else:
		change_scene("res://UI/Game.tscn")

func on_error():
	$Update/CanvasLayer/ColorRect/Label.text = "请检查网络连接"
