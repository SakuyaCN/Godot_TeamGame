extends Control

var buildData:Dictionary
onready var build_item_label = preload("res://UI/ItemUI/BuidlItemLabel.tscn")
onready var build_type_item = preload("res://UI/ItemUI/BuildGridTypeItem.tscn")
onready var build_grid_item = preload("res://UI/ItemUI/BuildGridItem.tscn")
onready var build_info_need = preload("res://UI/ItemUI/BuildInfoNeedItem.tscn")

var choose_data
var choose_type = "武器"

func _ready():
	$NinePatchRect/ScrollContainer.get_v_scrollbar().set("custom_styles/scroll",StyleBoxTexture.new())
	$ScrollContainer.get_h_scrollbar().set("custom_styles/scroll",StyleBoxTexture.new())
	$NinePatchRect/ScrollContainer.get_v_scrollbar().set("custom_styles/scroll",StyleBoxTexture.new())
	buildData = LocalData.build_data
	visible = false
	loadBuildData()

func loadBuildData():
	for item in buildData["build_type"]:
		var label_ins = build_item_label.instance()
		label_ins.text = item
		$NinePatchRect/ScrollContainer/VBoxContainer.add_child(label_ins)
		label_ins.connect("pressed",self,"build_first_click",[item])
	loadBuildType(buildData["build_type"].keys()[0])

func loadBuildType(type):
	for item in $ScrollContainer/HBoxContainer.get_children():
		if item:
			item.queue_free()
	if buildData["build_type"][type].size() == 0:
		ConstantsValue.ui_layer.showMessage("暂无内容，敬请期待！",2)
	$ScrollContainer/HBoxContainer.get_children().clear()
	for item in buildData["build_type"][type]:
		var type_item = build_type_item.instance()
		type_item.text = item
		type_item.connect("pressed",self,"loadBuildTypeData",[type,buildData["build_type"][type][item],item])
		$ScrollContainer/HBoxContainer.add_child(type_item)
	if buildData["build_type"][type].values().size() > 0:
		loadBuildTypeData(type,buildData["build_type"][type].values()[0],"武器")
	else:
		loadBuildTypeData(type,[],"武器")

#顶部类型点击
func loadBuildTypeData(type,array,top_type):
	if $NinePatchRect3.visible && !$AnimationPlayer.is_playing():
		$AnimationPlayer.play_backwards("show")
	for item in $NinePatchRect2/ScrollContainer/GridContainer.get_children():
		item.queue_free()
	$NinePatchRect2/ScrollContainer/GridContainer.get_children().clear()
	for id in array:
		var item_ins = build_grid_item.instance()
		var data = LocalData.build_data["build_data"][type][str(id)]
		item_ins.setData(data)
		item_ins.connect("pressed",self,"build_item_click",[type,data])
		$NinePatchRect2/ScrollContainer/GridContainer.add_child(item_ins)
	if array.size() > 0:
		choose_type = top_type

#左侧制作类型点击
func build_first_click(type):
	if $NinePatchRect3.visible && !$AnimationPlayer.is_playing():
		$AnimationPlayer.play_backwards("show")
	loadBuildType(type)

#中间物品点击
func build_item_click(type,data):
	choose_data = data
	if $AnimationPlayer.is_playing():
		yield($AnimationPlayer,"animation_finished")
	if !$NinePatchRect3.visible:
		$AnimationPlayer.play("show")
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
	if !visible:
		$AnimationPlayer.play_backwards("show")
	$NinePatchRect3.visible = false

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		buildChange(false)

func get_context_label(type,data):
	$NinePatchRect3/context.clear()
	$NinePatchRect3/context.append_bbcode("炼制出的装备属性浮动：\n")
	match type:
		"基础装备":
			if data.keys().has("attr"):
				for attr in data.attr:
					$NinePatchRect3/context.append_bbcode(EquUtils.get_attr_string(attr))
					$NinePatchRect3/context.append_bbcode(" %s - %s" %[data.attr[attr][0],data.attr[attr][1]])
					$NinePatchRect3/context.append_bbcode("\n")
			if data.keys().has("ys_attr"):
				for attr in data.ys_attr:
					$NinePatchRect3/context.append_bbcode("[color=%s]" %EquUtils.get_ys_color_string(attr))
					$NinePatchRect3/context.append_bbcode(EquUtils.get_ys_string(attr))
					$NinePatchRect3/context.append_bbcode(" %s - %s" %[data.ys_attr[attr][0],data.ys_attr[attr][1]])
					$NinePatchRect3/context.append_bbcode("\n")

func _on_Button_pressed():
	EquUtils.createNewEqu(choose_data,choose_type)
	ConstantsValue.ui_layer.getNewItem(choose_data.name,choose_data.img)
