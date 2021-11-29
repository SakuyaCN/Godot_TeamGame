extends Node

var game_hangup = preload("res://UI/GoodsDialog/HangUp.tscn")

func _ready():
	pass

func on_login():
	var http = GodotHttp.new()
	http.connect("http_res",self,"on_http")
	var query = JSON.print({
		"uuid":OS.get_unique_id(),
		"save_id":StorageData.get_player_state()["save_id"]
	})
	http.http_post("login",query)

func on_http(url,data):
	if data.success:
		var ins = game_hangup.instance()
		add_child(ins)
		ins.hangUp(get_parent().player_array,data["data"].ts)
		get_parent().is_hangup = false
