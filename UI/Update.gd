extends Node

export var code = 0

var download_path = "user://download/"

var crypto = Crypto.new()
var key = CryptoKey.new()
var cert = X509Certificate.new()
onready var http_req = get_parent().find_node("HTTPRequest")
var path = []
var local_path = []
var download_size = 0
var last_version = 0
var is_file = false

func _ready():
	code = ConfigScript.getNumberSetting("system","version")
	#dir_contents(download_path)
	#check_update()
	
func dir_contents(_path):
	var dir = Directory.new()
	if dir.open(_path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() && file_name.countn(".zip"):
				local_path.append("user://download/%s" %file_name)
			file_name = dir.get_next()
	else:
		dir.make_dir(download_path)
	for st in local_path:
			ProjectSettings.load_resource_pack(st) 

func check_update():
	$Timer.start()
	http_req.use_threads = true
	http_req.request("http://150.158.34.28:8855/api/static/version?code=%s"%code)

func http_res(data):
	if data["data"].is_update:
		$Timer.stop()
		is_file = true
		for ver in data["data"].path:
			last_version = ver.version
			var p = "user://download/%s.zip" %ver.version
			var http = HTTPRequest.new()
			add_child(http)
			http.use_threads = true
			path.append(p)
			http.download_file = p
			http.request(ver.path)
			http.connect("request_completed",self,"_on_HTTPRequest_request_completed")
			$CanvasLayer/ColorRect/Label2.text = "正在下载更新内容..."
	else:
		get_parent().change_scene("res://UI/Game.tscn")

func http_download():
	download_size += 1
	$CanvasLayer/ColorRect/Label2.text = "下载完成...（%s）" %download_size
	if download_size == path.size():
		$CanvasLayer/ColorRect/Label2.text = "正在安装更新内容..."
		pckInstert()

func pckInstert():
	for st in path:
		ProjectSettings.load_resource_pack(st) 
	$CanvasLayer/ColorRect/Label2.text = "更新完成"
	get_parent().change_scene("res://UI/Game.tscn")
	ConfigScript.setValueSetting("system","version",last_version)
	
func _on_Timer_timeout():
	get_parent().change_scene("res://UI/Game.tscn")

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if body != null && response_code == 200:
		if !is_file:
			var json = JSON.parse(body.get_string_from_utf8())
			http_res(json.result)
		else:
			http_download()
