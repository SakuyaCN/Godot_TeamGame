extends Control

var build_info_need = preload("res://UI/ItemUI/BuildInfoNeedItem.tscn")

func hangUp(_player_array,ts):
	var map_index = StorageData.storage_data["player_state"]["map_index"]
	var player_map = StorageData.storage_data["player_state"]["map"][str(map_index)]["now_map"]
	var map_name  = (player_map/10) as int	
	var moster_name = LocalData.map_data[Utils.getMapName(map_name)].moster
	var win_goods = LocalData.moster_data[moster_name].win_data.duplicate(true)
	var goods_array = []
	var _exp = (1 + (player_map / 10.0) + (map_index * 65)) * win_goods.other.exp + (60 *  (map_index * map_index) * 1.55)
	_exp *= (ts / 20)
	var _gold = (ts / 15)
	var hm_gold = (ts / 120) as int
	if hm_gold > 0:
		win_goods.goods.append(["荒漠铜币串",1,50])
	for item in stroneDl():
		win_goods.goods.append(item)
	StorageData.get_player_state()["gold"] += _gold
	for item in win_goods.goods:
		if item[0] == "荒漠铜币串":
			goods_array.append([item[0],hm_gold])
		else:
			var gnum = (item[1] as int+randi() % item[2] as int)
			gnum += gnum * (1 + map_index)
			gnum *= (ts / 20) * rand_range(0.2,0.3)
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
	$win/Label2.text = "累计挂机时间：%s"%Utils.get_time_string(ts)
	
func stroneDl():
	var arr = []
	var map_index = StorageData.storage_data["player_state"]["map_index"] as int
	match map_index:
		0:
			arr.append(["初级助战进阶石",rand_range(5,10) as int,2])
		1:
			arr.append(["初级助战进阶石",rand_range(5,10) as int,3])
			arr.append(["中级助战进阶石",rand_range(2,4) as int,1])
		2:
			arr.append(["中级助战进阶石",rand_range(2,4) as int,2])
			arr.append(["高级助战进阶石",rand_range(1,2) as int,1])
		3:
			arr.append(["初级助战进阶石",rand_range(5,10) as int,3.5])
			arr.append(["中级助战进阶石",rand_range(2,4) as int,2])
			arr.append(["高级助战进阶石",rand_range(1,2) as int,1])
		4:
			arr.append(["初级助战进阶石",rand_range(5,11) as int,4])
			arr.append(["中级助战进阶石",rand_range(2,5) as int,2])
			arr.append(["高级助战进阶石",rand_range(1,3) as int,1])
	return arr

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		queue_free()
