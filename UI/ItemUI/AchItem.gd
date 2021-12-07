extends Control

onready var build_info_need = preload("res://UI/ItemUI/BuildInfoNeedItem.tscn")

var data
var type

func setData(_type,_data):
	type = _type
	data = _data
	reload()

func reload():
	if StorageData.get_player_state()["ach_array"].has(data.name):
		$ColorRect.visible = true
	$Label.text = data.name
	for need in data.goods:
		var ins = build_info_need.instance()
		ins.setData(need[0],need[1])
		$GridContainer.add_child(ins)

func _on_Control_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if !StorageData.get_player_state()["ach_array"].has(data.name):
			match type:
				"map":
					var player_map = StorageData.storage_data["player_state"]["map"][str(data.need[0])]["max_map"]
					if  player_map >= data.need[1]:
						StorageData.get_player_state()["ach_array"].append(data.name)
						StorageData.AddGoodsNum(data.goods)
						reload()
					else:
						ConstantsValue.showMessage("请先完成【%s】"%data.name,2)
				"win":
					if StorageData.storage_data["player_state"]["win_count"] >= data.need[1]:
						StorageData.get_player_state()["ach_array"].append(data.name)
						StorageData.AddGoodsNum(data.goods)
						reload()
					else:
						ConstantsValue.showMessage("请先完成【%s】"%data.name,2)
		else:
			ConstantsValue.showMessage("无法重复领取成就奖励！",2)
