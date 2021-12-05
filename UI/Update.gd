extends Node

export var code = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	#check_update()
	pass

func check_update():
	var http = GodotHttp.new()
	http.http_get("static/version?code=%s"%code)
	http.connect("http_res",self,"http_res")

func http_res(_url,data):
	if data["data"].is_update:
		pass
	else:
		ConstantsValue.showMessage("已是最新版本",3)
