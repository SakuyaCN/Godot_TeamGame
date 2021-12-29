extends Node2D

onready var moster = preload("res://Role/Moster/Motser.tscn")
onready var build_info_need = preload("res://UI/ItemUI/BuildInfoNeedItem.tscn")
onready var skill_item = preload("res://UI/GameLevel/GameLevelSkillItem.tscn")
var kill_count = 0
var moster_count = 1
var moster_max_count = 20
var moster_all_count = 20
var moster_alive_count = 20
var moster_data

var gold = 1

var player_skill = []
var player_array = [null,null,null]
var moster_array = []
var player_buff = []

var temp_goods = [
	["刻印碎片",10],
	["秘银矿石",1],
	["青岚铁矿",1],
	["暗蓝星矿",0]
]

func _ready():
	randomize()
	#LocalData.do_load()
	$CanvasLayer/Control.visible = false
	$CanvasLayer/ChooseUI.visible = true

func reloadCount():
	if moster_count % 5 == 0:
		$Timer.wait_time -= 0.04
	$CanvasLayer/Control/ColorRect2/all_count.text = "当前回合总敌人数量：%s" %moster_all_count
	$CanvasLayer/Control/ColorRect2/count.text = "当前战斗波数：%s"%moster_count
	loadMoster()
	$Timer.start()

func loadMoster():
	var moster_info = LocalData.moster_data["骷髅战士"]
	var attr = LocalData.map_data["0"]["骷髅战士"]
	var skill = []
	if attr.has("skill"):
		skill = attr.skill
	moster_data = {
		"nickname":"骷髅战士",
		"job":"moster",
		"lv":50,
		"atk_count":1,
		"attr":mosterAttr(attr),
		"equ":{},
		"skill":skill,
		"node":moster_info
	}

func mosterAttr(attr):
	var new_attr = {}
	for item in attr:
		new_attr[item] = attr[item]
		if item == "hp":
			new_attr[item] = attr[item] + getHpCount()
		if item == "def" || item == "mdef":
			new_attr[item] = 5 + getdefCount()
		if item == "atk":
			new_attr[item] = 5 + getAtkCount()
	attr.other = {
		"atk_pass":getPassCount()
	}
	return new_attr

func getHpCount():
	if moster_count < 5:
		return 300 * moster_count
	elif 5 <= moster_count && moster_count < 10:
		return 900 * moster_count * 1.2
	elif 10 <= moster_count && moster_count < 20:
		return 1500 * moster_count * 1.5
	elif 20 <= moster_count && moster_count < 30:
		return 2000 * moster_count * 1.8
	else:
		return 4000 * moster_count * 2.7

func getdefCount():
	if moster_count < 5:
		return 0.4 * moster_count
	elif 5 <= moster_count && moster_count < 10:
		return 0.6 * moster_count
	elif 10 <= moster_count && moster_count < 20:
		return 1.3 * moster_count
	elif 20 <= moster_count && moster_count < 30:
		return 2.1 * moster_count
	else:
		return 3.3 * moster_count

func getPassCount():
	if moster_count < 5:
		return 0.2 * moster_count
	elif 5 <= moster_count && moster_count < 10:
		return 0.3 * moster_count
	elif 10 <= moster_count && moster_count < 20:
		return 0.5 * moster_count
	elif 20 <= moster_count && moster_count < 30:
		return 0.7 * moster_count
	else:
		return 1 * moster_count

func getAtkCount():
	if moster_count < 5:
		return 15 * moster_count * 0.8
	elif 5 <= moster_count && moster_count < 10:
		return 35 * moster_count * 0.9
	elif 10 <= moster_count && moster_count < 20:
		return 75 * moster_count * 1.05
	elif 20 <= moster_count && moster_count < 30:
		return 150 * moster_count * 1.15
	else:
		return 300 * moster_count * 1.3

func game_start():
	reloadCount()
	$CanvasLayer/Control.visible = true
	player_array[0].fight_script.connect("onDie",self,"player_die")
	player_array[0].setRoleScript(moster_array,player_array)


func _on_Timer_timeout():
	if moster_all_count != 0:
		moster_all_count -= 1
		var moster_ins = moster.instance()
		$Position2D2.add_child(moster_ins)
		moster_ins.fight_script.connect("onDie",self,"moster_die")
		moster_ins.set_role(moster_data)
		moster_ins.setRoleScript(player_array,moster_array)
		moster_ins.run2position($Position2D)
		moster_array.append(moster_ins)
		for item in player_array:
			if item != null && !item.is_start_fight:
				yield(get_tree().create_timer(1),"timeout")
				item.start_fight()

func game_over():
	$CanvasLayer/fail.visible = true
	$Timer.stop()
	for item in moster_array:
		item.queue_free()
	for item in player_array:
		if item != null:
			item.queue_free()
	moster_array.clear()
	player_array.clear()

func player_die(node):
	game_over()

func moster_die(node):
	kill_count += 1
	moster_array.erase(node)
	node.queue_free()
	moster_alive_count -= 1
	if moster_alive_count == 0 && moster_all_count == 0:
		count_over()
	$CanvasLayer/Control/ColorRect2/all_count2.text = "累计杀敌：%s" %kill_count
	$CanvasLayer/Control/ColorRect2/all_count.text = "当前回合总敌人数量：%s/%s" %[moster_alive_count,moster_max_count]

#回合战斗结束
func count_over():
	for skill in $CanvasLayer/Control/HBoxContainer.get_children():
		skill.queue_free()
	$CanvasLayer/Control/HBoxContainer.get_children().clear()
	$CanvasLayer/win.visible = true
	$Timer.stop()
	$Timer2.stop()
	moster_count += 1
	for item in player_array:
		if item != null:
			item.role_reset()
	$CanvasLayer/Control/ColorRect2/all_count.text = "3秒后发起下一波攻势！"
	showWinBox()

func nextRound():
	$CanvasLayer/win.visible = false
	moster_all_count = 20 + (moster_count * 2)
	moster_alive_count = moster_all_count
	moster_max_count = moster_all_count
	reloadCount()
	for item in player_array:
		if item != null:
			item.reloadAttr(player_buff)
	$Timer.start()
	$Timer2.start()

func _on_StaticBody2D2_body_entered(body):
	body.start_fight()

func showWinBox():
	chooseBuff()
	StorageData.get_player_state()["gold"] += 50 * gold
	var goods = getWinGoods()
	goods.append(["刻印碎片",10 * gold])
	goods.append(["火焰之石",2 * gold])
	if randi()%100 < 5:
		goods.append(["助战宝箱",1 * gold])
	StorageData.AddGoodsNum(goods)
	for item in $CanvasLayer/win/GridContainer.get_children():
		item.queue_free()
	for item in goods:
		if item[1] > 0:
			var ins = build_info_need.instance()
			$CanvasLayer/win/GridContainer.add_child(ins)
			ins.need_tips = false
			ins.setData(item[0],item[1])
	$CanvasLayer/win.visible = true
	$CanvasLayer/win/Label.text = "回合胜利奖励+%s金币" %str(50 * gold) 

func getWinGoods():
	if moster_count < 5:
		return [
			["红色陨铁",10 * moster_count * gold],
			["绿色陨铁",5 * moster_count * gold],
		]
	elif 5 <= moster_count && moster_count < 10:
		return [
			["红色陨铁",12 * moster_count * gold],
			["绿色陨铁",7 * moster_count * gold],
		]
	elif 10 <= moster_count && moster_count < 20:
		return [
			["秘银矿石",2 * moster_count * gold],
			["绿色陨铁",10 * moster_count * gold],
		]
	elif 20 <= moster_count && moster_count < 30:
		return [
			["青岚铁矿",(moster_count / 5.0) as int * gold],
			["暗蓝星矿",(moster_count / 10.0) as int * gold],
		]
	else:
		return [
			["青岚铁矿",(moster_count / 3.0) as int * gold],
			["暗蓝星矿",(moster_count / 7.0) as int * gold],
		]

#游戏结束返回
func _on_ColorRect2_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		ConstantsValue.game_mode_change = true
		$UILayer.change_scene("res://UI/Game.tscn")

func addSkill(skill_data):
	var ins = skill_item.instance()
	$CanvasLayer/Control/HBoxContainer.add_child(ins)
	ins.setData(skill_data)
	ins.connect("pressed",self,"_on_skill_click",[ins,skill_data])

func _on_skill_click(_ins,_skill_data):
	for item in player_array:
		if item != null:
			item.AddRoleSkill(_skill_data)
	_ins.queue_free()

func chooseBuff():
	var buff = []
	match moster_count:
		1,2,3,4:
			buff = buffList[0].duplicate()
		5,6,7,8,9:
			buff = buffList[1].duplicate()
		_:buff = buffList[2].duplicate()
	buff.shuffle()
	for item in $CanvasLayer/win/BUFF.get_children():
		item.setData(buff.pop_front())

var buffList = [
	[
		["hp",500],["atk",200],["speed",200],["mtk",200],["def",1],["uncrit",200],["crit",200],["shield",1000]
	],
		#第5-10关BUFF
	[
		["hp",1000],["atk",300],["speed",500],["mtk",300],["def",2],["uncrit",500],["crit",500],["shield",3000],
		["true_hurt",60],["hold",2],["hole_num",100],["dodge",1],["mtk_pass",2],["atk_pass",2],["atk_blood",5],["mtk_blood",5]
	],
		#第5-10关BUFF
	[
		["hp",2000],["atk",500],["speed",1000],["mtk",500],["def",3],["uncrit",1000],["crit",1000],["shield",3500],
		["true_hurt",150],["hold",4],["hole_num",500],["mtk_pass",5],["atk_pass",5],["atk_blood",10],["mtk_blood",10],
		["shield_buff",10],["atk_mtk",5],["skill_crit",500],["reflex",3],["atk_pass",5],["crit_buff",10],["hurt_buff",10]
	]
]

var buff_click = false
func _on_Control_pressed(args):
	if buff_click:
		return
	player_buff.append($CanvasLayer/win/BUFF.get_child(args).buff)
	ConstantsValue.showMessage("获得BUFF【%s】 + %s"%[EquUtils.get_attr_string($CanvasLayer/win/BUFF.get_child(args).buff[0]),$CanvasLayer/win/BUFF.get_child(args).buff[1]],2)
	$CanvasLayer/win.visible = false
	nextRound()
	buff_click = false

#查看冒险者属性
func _on_attrs_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if player_array[0] != null:
			ConstantsValue.showAttrBox($CanvasLayer,player_array[0].hero_attr)

func _on_Timer2_timeout():
	if $CanvasLayer/Control/HBoxContainer.get_child_count() < 5 && randi()%15 == 5:
		if StorageData.get_all_skill().size() > 0:
			addSkill(LocalData.skill_data[StorageData.get_all_skill()[randi()%StorageData.get_all_skill().size()].form])

#退出副本
var tap_one = 0
func _on_attrs2_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		tap_one += 1
		if tap_one == 2:
			ConstantsValue.game_mode_change = true
			$UILayer.change_scene("res://UI/Game.tscn")
		else:
			ConstantsValue.showMessage("双击退出副本",2)
		yield(get_tree().create_timer(0.5),"timeout")
		tap_one = 0

func _on_SpinBox_value_changed(value):
	gold = value as int
