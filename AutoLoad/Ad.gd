extends Node

var is_showing = false
var singleton = null
signal AdSuccess()

func _ready():
	if Engine.has_singleton("GodotUtils"):
		singleton = Engine.get_singleton("GodotUtils")
		singleton.connect("onAdResult",self,"onAdResult")

func onAdResult(result):
	match result:
		"Show":
			pass
			get_tree().paused = true
		"Closed":
			showSuccess()
			is_showing = false
			get_tree().paused = false
		"Failed":
			ConstantsValue.showMessage("广告正在加载失败",2)
			is_showing = false
		"Success":
			pass

func showAd():
	if OS.get_system_time_secs() - ConstantsValue.ad_time <= 10:
		ConstantsValue.showMessage("广告装载中，请过一会再来看吧",2)
		return
	if is_showing || singleton == null:
		ConstantsValue.showMessage("广告正在加载",2)
		return
	singleton.showRewardVideoAD()
	is_showing = true

func showSuccess():
	var http = GodotHttp.new()
	var query = JSON.print({
		"uuid":OS.get_unique_id(),
		"save_id":StorageData.get_player_state()["save_id"]
	})
	http.http_post("sign/ad_add",query)
	is_showing = false
	ConstantsValue.ad_time = OS.get_system_time_secs()
	emit_signal("AdSuccess")

func getAdCount():
	var http = GodotHttp.new()
	http.connect("http_res",self,"_http_res")
	var query = JSON.print({
		"uuid":OS.get_unique_id(),
		"save_id":StorageData.get_player_state()["save_id"]
	})
	http.http_post("sign/ad",query)

func _http_res(url,data):
	if data["data"].is_sign_gif:
		showAd()
	else:
		ConstantsValue.showMessage("观看次数已达上限",2)
