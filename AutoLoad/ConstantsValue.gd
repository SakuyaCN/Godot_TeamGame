extends Node2D

var ui_layer = null #ui界面 与游戏主题内容无关
var game_layer = null #ui界面 与游戏交互
var const_choose_role_arrt = null #点击人物展示数据面板
var tree = null

var array_num = 0#拾取等级
var is_fight_num#战斗信息是否展示
var fight_array

onready var seal_box = preload("res://UI/ControlUI/SealBox.tscn")
onready var attr_box = preload("res://UI/ControlUI/OhterAttr.tscn")

func configSet():
	is_fight_num = ConfigScript.getBoolSetting("fight","fight_num")#战斗信息是否展示
	fight_array = ConfigScript.getArraySetting("fight","fight_array")
	array_num = ConfigScript.getNumberSetting("fight","array_num")

func reloadAllEqu():
	tree.call_group("PartyUI","loadAllEqu")

func showMessage(st,time):
	ui_layer.showMessage(st,time)

func showSealBox(_data,node = null):
	var ins = seal_box.instance()
	ins.showBox(_data)
	if node != null:
		ins.connect("seal_choose",node,"seal_choose")
	ui_layer.add_box.add_child(ins)

func showAttrBox(node,_data):
	var ins = attr_box.instance()
	ins.showAttr(node,_data)

func updateFightNum():
	is_fight_num = ConfigScript.getBoolSetting("fight","fight_num")

func updateFightArray():
	fight_array = ConfigScript.getArraySetting("fight","fight_array")
