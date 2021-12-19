extends Control

var buildData:Dictionary
onready var build_item_label = preload("res://UI/ItemUI/BuidlItemLabel.tscn")
onready var build_type_item = preload("res://UI/ItemUI/BuildGridTypeItem.tscn")
onready var build_grid_item = preload("res://UI/ItemUI/BuildGridItem.tscn")
onready var build_info_need = preload("res://UI/ItemUI/BuildInfoNeedItem.tscn")

var choose_id #选中道具的ID
var choose_data
var choose_type #顶部二级选中类别
var left_type #左侧选中类别
var build_num = 1

func _ready():
	$NinePatchRect/ScrollContainer.get_v_scrollbar().set("custom_styles/scroll",StyleBoxTexture.new())
	$ScrollContainer.get_h_scrollbar().set("custom_styles/scroll",StyleBoxTexture.new())
	$NinePatchRect/ScrollContainer.get_v_scrollbar().set("custom_styles/scroll",StyleBoxTexture.new())
	buildData = LocalData.build_data
	loadBuildData()
	buildChange(true)

#加载一级分类数据
func loadBuildData():
	for item in buildData["build_type"]:
		var label_ins = build_item_label.instance()
		label_ins.text = item
		$NinePatchRect/ScrollContainer/VBoxContainer.add_child(label_ins)
		label_ins.connect("pressed",self,"build_first_click",[item])
	#loadBuildType(buildData["build_type"].keys()[0])

#加载一级分类下首个数据
func loadBuildType(type):
	for item in $ScrollContainer/HBoxContainer.get_children():
		if item:
			item.queue_free()
	if buildData["build_type"][type].size() == 0:
		ConstantsValue.showMessage("暂无内容，敬请期待！",1)
	$ScrollContainer/HBoxContainer.get_children().clear()
	for item in buildData["build_type"][type]:
		var type_item = build_type_item.instance()
		type_item.text = item
		type_item.connect("pressed",self,"loadBuildTypeData",[type,buildData["build_type"][type][item],item])
		$ScrollContainer/HBoxContainer.add_child(type_item)
	if buildData["build_type"][type].values().size() > 0:
		loadBuildTypeData(type,buildData["build_type"][type].values()[0],buildData["build_type"][type].keys()[0])
	else:
		loadBuildTypeData("",[],"")
		ConstantsValue.showMessage("暂无内容，敬请期待！",1)

#顶部类型点击
func loadBuildTypeData(type,array,top_type):
	if $NinePatchRect3.visible:
		$NinePatchRect3.visible = false
	for item in $NinePatchRect2/ScrollContainer/GridContainer.get_children():
		item.queue_free()
	$NinePatchRect2/ScrollContainer/GridContainer.get_children().clear()
	for id in array:
		var item_ins = build_grid_item.instance()
		var data = {}
		match type:
			"技能书":
				var temp = LocalData.skill_data[str(id)].duplicate()
				data.id = temp.skill_id
				data.name = temp.skill_name
				data.lv = temp.skill_lv
				data.img = temp.image
				data.info = temp.skill_info
				data.need = LocalData.build_data["build_data"][type][str(id)].need
			"套装附魔":
				var temp = LocalData.tz_data[id].duplicate()
				data.id = id
				data.name = temp.name
				data.lv = temp.lv
				data.img = temp.img
				data.info = EquUtils.getTzInfo(temp.attr)
				data.need = LocalData.build_data["build_data"][type][id].need
				data.temp = temp
			_:
				data = LocalData.build_data["build_data"][type][str(id)]
		item_ins.setData(data)
		item_ins.connect("pressed",self,"build_item_click",[type,data,id])
		$NinePatchRect2/ScrollContainer/GridContainer.add_child(item_ins)
	if array.size() > 0:
		choose_type = top_type

#左侧制作类型点击
func build_first_click(type):
	loadBuildType(type)
	if $NinePatchRect3.visible:
		$NinePatchRect3.visible = false

#中间物品点击
func build_item_click(type,data,_id):
	choose_id = _id
	choose_data = data
	if type =="材料":
		$NinePatchRect3/bs.visible = true
	else:
		$NinePatchRect3/bs.visible = false
	if !$NinePatchRect3.visible:
		$NinePatchRect3.visible = true
	$NinePatchRect3/title.text = data.name + " lv.%s" %data.lv
	get_context_label(type,data)
	for item in $NinePatchRect3/GridContainer.get_children():
		item.queue_free()
	$NinePatchRect3/GridContainer.get_children().clear()
	for need in data.need:
		var ins = build_info_need.instance()
		ins.setData(need[0],need[1])
		$NinePatchRect3/GridContainer.add_child(ins)

func buildChange(change):
	visible = change
	$NinePatchRect3.visible = false
	if visible && !ConfigScript.getBoolSetting("store","first_open_build"):#首次打开炼金台
		var new_dialog = Dialogic.start('first_open_build')
		add_child(new_dialog)
		ConfigScript.setBoolSetting("store","first_open_build",true)
	if visible:
		loadBuildType(buildData["build_type"].keys()[0])

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().queue_delete(self)

func get_context_label(type,data):
	left_type = type
	$NinePatchRect3/context.clear()
	match type:
		"基础装备", "神话装备":
			$NinePatchRect3/context.append_bbcode("%s属性浮动(实际可能会超出上限或低于下限根据品质决定)：\n" %data.type)
			if data.keys().has("attr"):
				for attr in data.attr:
					$NinePatchRect3/context.append_bbcode(EquUtils.get_attr_string(attr))
					$NinePatchRect3/context.append_bbcode(" %s - %s" %[data.attr[attr][0],(data.attr[attr][1] * EquUtils.getQualityBs("S++") )as int])
					$NinePatchRect3/context.append_bbcode("\n")
			if data.keys().has("ys_attr"):
				for attr in data.ys_attr:
					$NinePatchRect3/context.append_bbcode("[color=%s]" %EquUtils.get_ys_color_string(attr))
					$NinePatchRect3/context.append_bbcode(EquUtils.get_ys_string(attr))
					$NinePatchRect3/context.append_bbcode(" %s - %s" %[data.ys_attr[attr][0],(data.ys_attr[attr][1] * EquUtils.getQualityBs("S++") )as int])
					$NinePatchRect3/context.append_bbcode("\n")
		"材料":
			$NinePatchRect3/context.append_bbcode("道具简介：\n")
			$NinePatchRect3/context.append_bbcode(LocalData.all_data["goods"][data.name].info)
		"刻印":
			$NinePatchRect3/context.append_bbcode(data.info+"\n")
			if data.keys().has("attr"):
				for attr in data.attr:
					$NinePatchRect3/context.append_bbcode(EquUtils.get_attr_string(attr))
					$NinePatchRect3/context.append_bbcode(" %s - %s" %[data.attr[attr][0],(data.attr[attr][1])as int])
					$NinePatchRect3/context.append_bbcode("\n")
		"技能书":
			$NinePatchRect3/context.append_bbcode("技能说明：\n")
			$NinePatchRect3/context.append_bbcode(data.info)
		"套装附魔":
			$NinePatchRect3/context.append_bbcode("套装属性介绍：\n")
			$NinePatchRect3/context.append_bbcode(data.info)

func _on_Button_pressed():
	if !Utils.is_lv_ok(choose_data.lv):
		ConstantsValue.showMessage("至少需要一名冒险者达到%s级才可以制作"%choose_data.lv,2)
		return
	if StorageData.get_player_equipment().size()>=100 && (left_type == "基础装备" || left_type == "神话装备"):
		ConstantsValue.showMessage("武器库已满，请及时清理！",3)
		return
	var need = choose_data.need.duplicate(true)
	if left_type == "材料":
		for item in need:
			item[1] *= build_num
	if need[0][0] == "金币":
		if StorageData.useGold(need[0][1]):
			get_goods(need)
		else:
			ConstantsValue.showMessage("金币不足！",2)
	else:
		if StorageData.UseGoodsNum(need):
			get_goods(need)

func get_goods(need):
	match left_type:
		"基础装备", "神话装备":
			EquUtils.createNewEqu(choose_id,left_type,choose_data,choose_data.type)
		"材料":
			StorageData.AddGoodsNum([[choose_data.name,1 * build_num]])
		"刻印":
			if StorageData.get_player_state().has("seal_return_lv"):
				var num = (StorageData.get_player_state()["seal_return_lv"] * 5) / 100.0
				var seal_num = (need[0][1] * num) as int
				if seal_num > 0:
					StorageData.AddGoodsNum([[need[0][0],seal_num]])
			StorageData.AddSeal(choose_data)
		"技能书":
			StorageData.AddSkill(choose_data)
		"套装附魔":
			StorageData.AddTz(choose_data.id,choose_data.temp)

#十倍打造
func _on_bs_pressed(args):
	build_num = args
