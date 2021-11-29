extends Control

onready var build_info_need = preload("res://UI/ItemUI/BuildInfoNeedItem.tscn")

func _ready():
	for item in ConstantsValue.static_goods:
		var ins  = build_info_need.instance()
		ins.setData(item[0],item[1])
		$win/GridContainer.add_child(ins)
	
func _on_Button_pressed():
	var http = GodotHttp.new()
	http.connect("http_res",self,"on_http")
	var query = JSON.print({
		"uuid":OS.get_unique_id(),
		"save_id":StorageData.get_player_state()["save_id"]
	})
	http.http_post("sign",query)

func on_http(url,data):
	if data["data"].is_sign_gif:
		StorageData.AddGoodsNum(ConstantsValue.static_goods)
		ConstantsValue.showMessage("领取成功！",2)
	else:
		ConstantsValue.showMessage("今天已经领取过了",2)
	queue_free()


func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		queue_free()
