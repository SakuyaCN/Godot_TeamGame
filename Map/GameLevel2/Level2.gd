extends Node2D

var role = preload("res://Role/BaseRole.tscn")
var moster = preload("res://Map/GameLevel2/BaseFireMoster.tscn")

var player_array = []
var moster_array = []

onready var lineEdit = $CanvasLayer/ChooseUI/NinePatchRect/LineEdit
onready var hpbar = $CanvasLayer/HpUI/progress_hp
onready var hpbar_tv = $CanvasLayer/HpUI/progress_hp/label_hp

var time_out = 30
var choose_lv = 0#选择框ID
var choose_hero = null

onready var role_position = [
	$GameMain/Position/PositionP1,
	$GameMain/Position/PositionP2,
	$GameMain/Position/PositionP3
]

var boss_hp = [
	100000000,
	1000000000,
	10000000000,
	100000000000,
]

func _ready():
	LocalData.do_load()
	lineEdit.add_item("50级",0)
	lineEdit.add_item("75级",1)
	lineEdit.add_item("100级",2)
	lineEdit.add_item("120级",3)

func _process(delta):
	$ParallaxBackground/ParallaxLayer2.motion_offset.x += delta * 10
	$ParallaxBackground/ParallaxLayer3.motion_offset.x -= delta * 10
	$ParallaxBackground/ParallaxLayer4.motion_offset.x += delta * 10
	$ParallaxBackground/ParallaxLayer5.motion_offset.x -= delta * 10
	$ParallaxBackground/ParallaxLayer6.motion_offset.x += delta * 10
	$ParallaxBackground/ParallaxLayer7.motion_offset.x -= delta * 10

func setHero():
	for pos in range(3):
		if StorageData.player_state["team_position"][pos] != null:
			if role_position[pos].get_child_count() == 0:
				var new_hero = role.instance()
				player_array.append(new_hero)
				new_hero.setIndex(pos)
				role_position[pos].add_child(new_hero)
				new_hero.set_role(StorageData.team_data.get(StorageData.player_state["team_position"][pos]))
		else:
			player_array.append(null)

func setMoster():
	var new_hero = moster.instance()
	moster_array.append(new_hero)
	$GameMain/PositionMoster/PositionM1.add_child(new_hero)
	var moster_info = LocalData.moster_data[choose_hero]
	var moster_data = {
		"nickname":choose_hero,
		"job":"moster",
		"lv":100,
		"atk_count":moster_info.atk_count,
		"equ":{},
		"skill":[],
		"node":moster_info
	}
	var bean = mosterAttr()
	new_hero.set_role(moster_data,bean)
	hpbar.max_value = bean.max_hp
	hpbar.value = hpbar.max_value 
	hpbar_tv.text = "HP：%s" %hpbar.max_value
	new_hero.connect("onHpCHnage",self,"hp_change")

func hp_change(hp):
	hpbar.value = hp
	hpbar_tv.text = "HP：%s" %hpbar.max_value

func mosterAttr():
	var index = 0
	var attr = {}
	var bean = HeroAttrBean.new()
	for player in player_array:
		if player != null:
			index += 1
			var dict = player.hero_attr.toDict()
			for atr in dict:
				bean.updateNum(atr,(dict[atr] / 3) as int)
	bean.updateNum("hp",boss_hp[choose_lv] * (1+choose_lv))
	return bean
			

#退出副本
func _on_attrs3_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		ConstantsValue.game_mode_change = true
		$UILayer.change_scene("res://UI/Game.tscn")

#开始战斗
func _on_attrs4_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if choose_hero == null:
			ConstantsValue.showMessage("请选择挑战领主",1)
			return
		$CanvasLayer/HpUI/lv.text = "%s：%s" %[choose_hero,lineEdit.get_item_text(choose_lv)]
		setHero()
		setMoster()
		$CanvasLayer/ChooseUI.visible = false
		$CanvasLayer/HpUI.visible = true
		ConstantsValue.showMessage("2秒后开始挑战领主！",2)
		yield(get_tree().create_timer(2),"timeout")
		$CanvasLayer/HpUI/start_fight.visible = true

func _on_check_toggled(button_pressed, extra_arg_0):
	choose_hero = extra_arg_0

func _on_LineEdit_item_selected(index):
	choose_lv = index

func _on_Button_pressed():
	$CanvasLayer/ChooseUI/NinePatchRect/HBoxContainer/Button/check.pressed = true

func _on_Button2_pressed():
	$CanvasLayer/ChooseUI/NinePatchRect/HBoxContainer/Button2/check.pressed = true

#倒计时
func _on_Timer_timeout():
	if time_out == 0:
		pass
	else:
		time_out -= 1
		$CanvasLayer/HpUI/time.text = "倒计时：%s秒" %time_out

func _on_start_fight_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		$CanvasLayer/HpUI/start_fight.visible = false
		get_tree().call_group("player_role","setRoleScript",moster_array,player_array)
		get_tree().call_group("moster_role","setRoleScript",player_array,moster_array)
		yield(get_tree().create_timer(0.1),"timeout")
		get_tree().call_group("player_role","start_fight")
		get_tree().call_group("moster_role","start_fight")
