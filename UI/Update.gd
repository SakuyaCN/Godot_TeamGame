extends Node

export var code = 0

var crypto = Crypto.new()
var key = CryptoKey.new()
var cert = X509Certificate.new()

var path = []
# Called when the node enters the scene tree for the first time.
func _ready():
	code = ConfigScript.getNumberSetting("system","version")
	var dic = Directory.new()
	dic.make_dir("user://download")
	check_update()
	pass

func check_update():
	var http = GodotHttp.new()
	http.http_get("static/version?code=%s"%code)
	http.connect("http_res",self,"http_res")

func http_res(_url,data):
	if data["data"].is_update:
		for ver in data["data"].path:
			var p = "user://download/%s.pck" %ver.version
			path.append(p)
			var http = GodotHttp.new()
			http.file_download(p,ver.path)
	else:
		ConstantsValue.showMessage("已是最新版本",3)
