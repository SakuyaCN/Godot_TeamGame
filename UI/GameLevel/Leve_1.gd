extends Node2D

onready var moster = preload("res://Role/Moster/Motser.tscn")
onready var build_info_need = preload("res://UI/ItemUI/BuildInfoNeedItem.tscn")
onready var skill_item = preload("res://UI/GameLevel/GameLevelSkillItem.tscn")
var kill_count = 0
var moster_count = 1
var moster_all_count = 20
var moster_alive_count = 20
var moster_data

var player_array = [null,null,null]
var moster_array = []

var temp_goods = [
	["秘银矿石",1],
	["青岚铁矿",1],
	["暗蓝星矿",0]
]

func _ready():
	randomize()
	LocalData.do_load()
	$CanvasLayer/Control.visible = false
	$CanvasLayer/ChooseUI.visible = true

func reloadCount():
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
	return new_attr

func getHpCount():
	if moster_count < 5:
		return 30000 * moster_count
	elif 5 <= moster_count && moster_count < 10:
		return 100000 * moster_count
	elif 10 <= moster_count && moster_count < 20:
		return 800000 * moster_count
	elif 20 <= moster_count && moster_count < 30:
		return 1200000 * moster_count
	else:
		return 5000000 * moster_count

func getdefCount():
	if moster_count < 5:
		return 1 * moster_count
	elif 5 <= moster_count && moster_count < 10:
		return 2 * moster_count
	elif 10 <= moster_count && moster_count < 20:
		return 3 * moster_count
	elif 20 <= moster_count && moster_count < 30:
		return 4 * moster_count
	else:
		return 5 * moster_count

func getAtkCount():
	if moster_count < 5:
		return 150 * moster_count
	elif 5 <= moster_count && moster_count < 10:
		return 300 * moster_count
	elif 10 <= moster_count && moster_count < 20:
		return 500 * moster_count
	elif 20 <= moster_count && moster_count < 30:
		return 1000 * moster_count
	else:
		return 2000 * moster_count

func game_start():
	reloadCount()
	$CanvasLayer/Control.visible = true
	player_array[0].fight_script.connect("onDie",self,"player_die")
	player_array[0].setRoleScript(moster_array,player_array)

func _on_Timer_timeout():
	if moster_all_count != 0:
		if $CanvasLayer/Control/HBoxContainer.get_child_count() < 5:
			addSkill(LocalData.skill_data[StorageData.get_all_skill()[randi()%StorageData.get_all_skill().size()].form])
		moster_all_count -= 1
		var moster_ins = moster.instance()
		$Position2D2.add_child(moster_ins)
		moster_ins.fight_script.connect("onDie",self,"moster_die")
		moster_ins.set_role(moster_data)
		moster_ins.setRoleScript(player_array,moster_array)
		moster_ins.run2position($Position2D)
		moster_array.append(moster_ins)

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

#回合战斗结束
func count_over():
	$CanvasLayer/win.visible = true
	$Timer.stop()
	moster_count += 1
	for item in player_array:
		if item != null:
			item.role_reset()
	$CanvasLayer/Control/ColorRect2/all_count.text = "3秒后发起下一波攻势！"
	showWinBox()
	yield(get_tree().create_timer(3),"timeout")
	$CanvasLayer/win.visible = false
	reloadCount()
	moster_all_count = 30 + (moster_count * 10)
	moster_alive_count = moster_all_count
	$Timer.start()

func _on_StaticBody2D2_body_entered(body):
	body.start_fight()
	for item in player_array:
		if item != null && !item.is_start_fight:
			item.start_fight()

func showWinBox():
	var goods = getWinGoods()
	StorageData.AddGoodsNum(goods)
	for item in goods:
		if item[1] > 0:
			var ins = build_info_need.instance()
			$CanvasLayer/win/GridContainer.add_child(ins)
			ins.need_tips = false
			ins.setData(item[0],item[1])
	$CanvasLayer/win.visible = true

func getWinGoods():
	if moster_count < 5:
		return [
			["红色陨铁",10 * moster_count],
			["绿色陨铁",5 * moster_count],
		]
	elif 5 <= moster_count && moster_count < 10:
		return [
			["红色陨铁",12 * moster_count],
			["绿色陨铁",7 * moster_count],
		]
	elif 10 <= moster_count && moster_count < 20:
		return [
			["秘银矿石",2 * moster_count],
			["绿色陨铁",10 * moster_count],
		]
	elif 20 <= moster_count && moster_count < 30:
		return [
			["青岚铁矿",(moster_count / 8) as int],
			["暗蓝星矿",(moster_count / 16) as int],
		]
	else:
		return [
			["青岚铁矿",(moster_count / 7) as int],
			["暗蓝星矿",(moster_count / 14) as int],
		]

#胜利界面展示
func _on_win_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		$CanvasLayer/win.visible = false

#游戏结束返回
func _on_ColorRect2_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		ConstantsValue.game_mode_change = true
		$UILayer.change_scene("res://UI/Game.tscn")

func addSkill(skill_data):
	var ins = skill_item.instance()
	$CanvasLayer/Control/HBoxContainer.add_child(ins)
	ins.setData(skill_data)
	ins.connect("pressed",self,"_on_skill_click",[skill_data])

func _on_skill_click(_skill_data):
	for item in player_array:
		if item != null:
			item.AddRoleSkill(_skill_data)
