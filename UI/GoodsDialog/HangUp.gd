extends Control

var build_info_need = preload("res://UI/ItemUI/BuildInfoNeedItem.tscn")

func hangUp(_player_array,ts):
	var map_index = StorageData.storage_data["player_state"]["map_index"]
	var player_map = StorageData.storage_data["player_state"]["map"][str(map_index)]["now_map"]
	var map_name  = (player_map/10) as int	
	var moster_name = LocalData.map_data[Utils.getMapName(map_name)].moster
	var win_goods = LocalData.moster_data[moster_name].win_data
	var goods_array = []
	var _exp = (1 + (player_map / 10.0) + (map_index * 60)) * win_goods.other.exp + (60 *  (map_index * map_index) * 1.5)
	_exp *= (ts / 20)
	var _gold = (ts / 15)
	StorageData.get_player_state()["gold"] += _gold
	for item in win_goods.goods:
		var gnum = (item[1] as int+randi() % item[2] as int) * 0.6
		gnum += gnum * (1 + map_index)
		gnum *= ((ts / 25) * (item[3] / 100.0))
		if gnum as int > 0:
			goods_array.append([item[0],gnum as int])
	StorageData.AddGoodsNum(goods_array)
	for item in goods_array:
		var ins  = build_info_need.instance()
		ins.setData(item[0],item[1])
		$win/GridContainer.add_child(ins)
	if win_goods.other.has("exp"):
		for _role in _player_array:
			if _role != null:
				_role.addExp(_exp as int)
	$win/exp.text = "累计获得经验：%s\n（如有加成以实际为准）" %_exp as int
	$win/exp.text += "\n累计获得金币：%s\n（如有加成以实际为准）" %_gold as int
	$win/Label2.text = "累计离线时间：%s"%Utils.get_time_string(ts)
	


func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		queue_free()
