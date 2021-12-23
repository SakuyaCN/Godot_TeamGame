extends Control

onready var build_info_need = preload("res://UI/ItemUI/BuildInfoNeedItem.tscn")

var goods = [
	["荒漠金币",1],["神秘之石",1],["暗蓝星矿",2],["刻印碎片",10],["火焰之石",10],["半小时挂机卡",1],["助战宝箱",1]
]

func _ready():
	for item in goods:
		var ins  = build_info_need.instance()
		ins.setData(item[0],item[1])
		$win/GridContainer.add_child(ins)
	$Ad.connect("AdSuccess",self,"ad_success")
	
func ad_success():
	StorageData.AddGoodsNum(goods)
	ConstantsValue.showMessage("获得奖励！",2)
	queue_free()

func _on_Button_pressed():
	$Ad.getAdCount()

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
