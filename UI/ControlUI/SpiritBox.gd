extends Control

var role_data = null
var choose_data = null
var choose_id = null
var over_array = [null,null,null]
var over_array_id = [null,null,null]
onready var over_item = [
	$Item2/HBoxContainer/Node2D,
	$Item2/HBoxContainer/Node2D2,
	$Item2/HBoxContainer/Node2D3
]
onready var spinvItem = preload("res://UI/ItemUI/spiritItem.tscn")

func set_role(_role_data,_choose_id = null):
	role_data = _role_data
	if role_data == null:
		$Item/Button2.text = "丢弃"
	else:
		$Item/Button2.text = "上场"
	reload()
	if _choose_id!= null:
		choose_id = _choose_id
		choose_data = StorageData.get_all_spirit()[choose_id]
		item_click(choose_id,choose_data)

func reload():
	$Item2.visible = false
	for item in $NinePatchRect/ScrollContainer/GridContainer.get_children():
		item.queue_free()
	for item in StorageData.get_all_spirit():
		if StorageData.get_all_spirit().has(item) && StorageData.get_all_spirit()[item] != null:
			var ins = spinvItem.instance()
			$NinePatchRect/ScrollContainer/GridContainer.add_child(ins)
			ins.setSeal(StorageData.get_all_spirit()[item])
			ins.connect("pressed",self,"item_click",[item,StorageData.get_all_spirit()[item]])
			ins._label.visible = false
			for role in StorageData.get_all_team():
				if StorageData.get_all_team()[role].has("spirit") && StorageData.get_all_team()[role].spirit == item:
					ins.setLabel("出战中")
					ins._label.visible = true

func item_click(_id,_data):
	if $Item2.visible:
		for role in StorageData.get_all_team():
			if StorageData.get_all_team()[role].has("spirit") && StorageData.get_all_team()[role].spirit == _id:
				ConstantsValue.showMessage("无法放入已出战助战精灵",2)
				return
		chooseOver(_data,_id)
		return
	$Item.visible = true
	if role_data != null && role_data.has("spirit") && role_data.spirit == _id:
		$Item/Button2.text = "下场"
	elif role_data != null:
		$Item/Button2.text = "上场"
	else:
		$Item/Button2.text = "丢弃"
	choose_id = _id
	choose_data = _data
	needInfo()
	$Item/RichTextLabel.clear()
	$Item/RichTextLabel.append_bbcode("【Lv.%s】%s\n" %[_data.lv,_data.name])
	$Item/RichTextLabel.append_bbcode("【%s】属性转化率：%s \n" %[_data.quality,EquUtils.getQualityAttr(_data.quality)])
	$Item/RichTextLabel.append_bbcode("成长属性：\n")
	for attr in _data.base_attr:
		$Item/RichTextLabel.append_bbcode("%s : %s\n" %[EquUtils.get_attr_string(attr),_data.base_attr[attr] * _data.lv])
	for gem in _data.gems:
		pass
	for skill in _data.skill:
		pass

func chooseOver(_data,_id):
	if choose_data.quality == "神话":
		ConstantsValue.showMessage("已达到最高品质",2)
		return
	if choose_data == _data:
		ConstantsValue.showMessage("自身无法放入！",2)
		return
	if choose_data.quality != _data.quality:
		ConstantsValue.showMessage("必须放入相同品质的助战精灵",2)
		return
	if _data.lv < 100:
		ConstantsValue.showMessage("融合必须达到100级",2)
		return
	is_addBox(_data,_id)

func is_addBox(_data,_id):
	var is_add = false
	for item in over_array:
		if item != null && item == _data:
			ConstantsValue.showMessage("该助战已经放入",2)
			return
	for item in range(3):
		if over_array[item] == null:
			over_array[item] = _data
			over_array_id[item] = _id
			is_add = true
			overBoxReload()
			return
	if !is_add:
		ConstantsValue.showMessage("最多放入3个",2)

func overBoxReload():
	for item in range(3):
		if over_array[item] != null:
			over_item[item].setSeal(over_array[item])
		else:
			over_item[item].setSeal(null)

func needGold(lv):
	return (lv * lv) * (lv * 0.5) + 500

func needGoods(lv):
	if choose_data.lv >=40 && choose_data.lv < 60:
		return ["初级助战进阶石", (10 * (choose_data.lv * choose_data.lv * 0.06)) as int]
	elif choose_data.lv >=60 && choose_data.lv < 80:
		return ["中级助战进阶石",(7 * (choose_data.lv * choose_data.lv * 0.07)) as int]
	elif choose_data.lv >=80 && choose_data.lv < 100:
		return ["高级助战进阶石",(6 * (choose_data.lv * choose_data.lv * 0.1)) as int]
	return null

func needInfo():
	$Item/gold.text = "升级需要金币：%s" %needGold(choose_data.lv) as int
	var goods = needGoods(choose_data.lv)
	if goods != null:
		$Item/gold.text += "\n%s:%s" %[goods[0],goods[1]]

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		queue_free()

#升级
func _on_Button_pressed():
	if choose_data.lv == 100:
		ConstantsValue.showMessage("等级已满!",2)
		return
	var goods = needGoods(choose_data.lv)
	if goods != null && !StorageData.checkGoodsNum([goods]):
		ConstantsValue.showMessage("道具不足无法升级!",2)
		return
	if StorageData.useGold(needGold(choose_data.lv)):
		if goods != null:
			StorageData.UseGoodsNum([goods])
		choose_data.lv += 1
		item_click(choose_id,choose_data)
		ConstantsValue.showMessage("升级成功！",1)
	else:
		ConstantsValue.showMessage("升级失败，金币不足",1)

func _on_Button2_pressed():
	if role_data == null:
		drop()
	else:
		if role_data != null && role_data.has("spirit") && role_data.spirit == choose_id:
			role_data.spirit = null
		else:
			for role in StorageData.get_all_team():
				if StorageData.get_all_team()[role].has("spirit") && StorageData.get_all_team()[role].spirit == choose_id:
					StorageData.get_all_team()[role].spirit = null
			role_data.spirit = choose_id
		get_tree().call_group("PartyUI","checkHeroData")
		StorageData._save_storage()
		queue_free()

var discard_count = 0

func drop():
	discard_count += 1
	if discard_count == 2:
		if choose_data != null:
			$Item.visible = false
			getGold()
			StorageData.get_all_spirit().erase(choose_id)
			StorageData._save_storage()
			reload()
	else:
		ConstantsValue.showMessage("再点一次确认丢弃助战，丢弃只返回全部金币",1)
	yield(get_tree().create_timer(1),"timeout")
	discard_count = 0

func getGold():
	var gold = 0
	for lv in range(choose_data.lv):
		gold += needGold(lv)
	StorageData.get_player_state()["gold"] += gold as int
	ConstantsValue.showMessage("返还金币：%s" %gold as int ,2)

#融合按钮
func _on_Button3_pressed():
	if choose_data.quality == "神话":
		ConstantsValue.showMessage("已达到最高品质",2)
		return
	if !$Item2.visible:
		$Item2.visible = true


func _on_Node2D_pressed(_args):
	if over_array[_args] != null:
		over_array[_args] = null
		over_array_id[_args] = null
	overBoxReload()

func _on_Button4_pressed():
	$Item2.visible = false
	for index in range(3):
		over_array[index] = null
		over_array_id[index] = null
	overBoxReload()
#融合操作
func _on_over_pressed():
	if StorageData.get_player_state()["gold"] < 5000000:
		ConstantsValue.showMessage("金币不足，无法融合",2)
		return
	for item in over_array:
		if item == null:
			ConstantsValue.showMessage("请放入3个相同且等级为100的助战！",2)
			return
	StorageData.useGold(5000000)
	for id in over_array_id:
		StorageData.get_all_spirit().erase(id)
	match choose_data.quality:
		"S++":choose_data.quality = "史诗"
		"史诗":choose_data.quality = "传说"
		"传说":choose_data.quality = "神话"
	StorageData._save_storage()
	ConstantsValue.showMessage("融合成功！品质进阶为【%s】"%choose_data.quality,2)
	_on_Button4_pressed()
	reload()
	item_click(choose_id,choose_data)
