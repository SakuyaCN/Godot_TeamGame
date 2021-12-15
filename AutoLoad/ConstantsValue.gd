extends Node2D

var version = "110"
var ui_layer #ui界面 与游戏主题内容无关
var game_layer = null #ui界面 与游戏交互
var const_choose_role_arrt = null #点击人物展示数据面板
var tree = null
var game = null
var array_num = 0#拾取等级
var is_fight_num#战斗信息是否展示
var fight_array

var static_goods = {} #获取签到物品

var chat_array = []
signal on_chat_message(data)

#=========网络部分==========
var online_data
var online_attr

var GodotNakama:GodotNakamaClient
var session = null
var user_info = {
	"username":null,
	"user_id":null,
	"token":null
}
#==========================
var game_mode_change = 0 #是否从其他世界切换回来
#==========================
#==========================
onready var seal_box = preload("res://UI/ControlUI/SealBox.tscn")
onready var tz_box = preload("res://UI/ControlUI/TzBox.tscn")
onready var attr_box = preload("res://UI/ControlUI/OhterAttr.tscn")

func _init():
	GodotNakama = GodotNakamaClient.new()

func configSet():
	is_fight_num = ConfigScript.getBoolSetting("fight","fight_num")#战斗信息是否展示
	fight_array = ConfigScript.getArraySetting("fight","fight_array")
	array_num = ConfigScript.getNumberSetting("fight","array_num")
	configUserReload()
	
func configUserReload():
	user_info.username = ConfigScript.getNumberSetting("user","username")
	user_info.user_id = ConfigScript.getNumberSetting("user","user_id")
	user_info.token = ConfigScript.getNumberSetting("user","token")

func createClient():
	pass

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

func showTzBox(_data,node = null):
	var ins = tz_box.instance()
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
