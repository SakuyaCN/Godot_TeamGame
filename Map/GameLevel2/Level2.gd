extends Node2D

var role = preload("res://Role/BaseRole.tscn")
var moster = preload("res://Map/GameLevel2/BaseFireMoster.tscn")

var player_array = []
var moster_array = []

var gold = 0
var all_hurt = 0

var hurt_map = {
	
}

onready var lineEdit = $CanvasLayer/ChooseUI/NinePatchRect/LineEdit
onready var hpbar = $CanvasLayer/HpUI/progress_hp
onready var hpbar_tv = $CanvasLayer/HpUI/progress_hp/label_hp

var time_out = 30
var choose_lv = 0#选择框ID
var choose_hero = null
var bs = 1.0

onready var role_position = [
	$GameMain/Position/PositionP1,
	$GameMain/Position/PositionP2,
	$GameMain/Position/PositionP3
]

var boss_hp = [
	500000000,
	1000000000,
	10000000000,
	100000000000,
]

func _ready():
	$CanvasLayer/HpUI.visible = false
	$CanvasLayer/ChooseUI.visible = true
	$CanvasLayer/hurt_bd.visible = false
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
				new_hero.fight_script.connect("onDie",self,"on_role_die")
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
	new_hero.connect("onHpCHnage",self,"hp_change")
	new_hero.fight_script.connect("onDie",self,"on_role_die")
	new_hero.fight_script.connect("onHurt",self,"on_role_hurt")

func on_role_hurt(_role_data,hurt_num):
	if !hurt_map.has(_role_data.rid):
		hurt_map[_role_data.rid] = {
			"name":_role_data.nickname,
			"hurt":hurt_num
		}
	else:
		hurt_map[_role_data.rid].hurt += hurt_num
	var text = ""
	all_hurt = 0
	for item in hurt_map:
		all_hurt += hurt_map[item].hurt as int
		text += "%s ：%s \n"%[hurt_map[item].name,Utils.get_gold_string(hurt_map[item].hurt as int)]
	text += "总计伤害：%s" %Utils.get_gold_string(all_hurt)
	$CanvasLayer/hurt_bd/h1.text = text

func on_role_die(node):
	var is_moster_win = true
	var is_player_win = true
	for moster in moster_array:
		if moster.fight_script.is_alive:
			is_player_win = false
	for player in player_array:
		if player != null:
			if player.fight_script.is_alive:
				is_moster_win = false
	if is_player_win:
		over(true)
	if is_moster_win:
		over(false)

func over(is_win):
	$Timer.stop()
	for item in player_array:
		if item != null:
			item.queue_free()
	for item in moster_array:
		item.queue_free()
	$CanvasLayer/fail.visible = true
	var local_bs = bs
	if all_hurt <= 500000:
		local_bs += 2
	elif all_hurt < 5000000 && all_hurt > 500000:
		local_bs += 1.7
	elif all_hurt < 50000000 && all_hurt > 5000000:
		local_bs += 1.6
	elif all_hurt < 500000000 && all_hurt > 50000000:
		local_bs += 1.5
	elif all_hurt < 5000000000 && all_hurt > 500000000:
		local_bs += 1.4
	else:
		local_bs += 1.3
	if all_hurt > 10000000000:
		all_hurt = 10000000000 + all_hurt/50000
	if is_win:
		gold = 1000 + all_hurt / 6000 * local_bs * ((choose_lv * choose_lv + 1)/6 + 1)
		$CanvasLayer/fail/ColorRect2/count.text = "挑战胜利！"
	else:
		gold = 1000 + all_hurt / 9000 * local_bs * ((choose_lv * choose_lv + 1)/6 + 1)
		$CanvasLayer/fail/ColorRect2/count.text = "挑战失败！"
	$CanvasLayer/fail/ColorRect2/count2.text = "根据伤害获得金币+%s" %gold as int
	StorageData.get_player_state()["gold"] += gold as int
 
func hp_change(hp):
	hpbar.value = hp
	hpbar_tv.text = "HP：%s" %hp

func mosterAttr():
	match choose_hero:
		"火焰之王":
			bs = 1.5
	var index = 0
	var attr = {}
	var bean = HeroAttrBean.new()
	for player in player_array:
		if player != null:
			index += 1
			var dict = player.hero_attr.toDict()
			for atr in dict:
				bean.updateNum(atr,(dict[atr] / 5) * bs * ((choose_lv * choose_lv)/5.0 + 1))
	bean.updateNum("max_hp",boss_hp[choose_lv] * (1+choose_lv) * bs)
	bean.updateNum("hp",boss_hp[choose_lv] * (1+choose_lv) * bs)
	bean.updateNum("unpt",999999)
	var ps = bs * ((choose_lv * choose_lv)/5.0 + 1)
	bean.updateNum("mtk_pass",ps * 5)
	print(ps)
	return bean

#退出副本
var tap_one = 0
func _on_attrs3_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		tap_one += 1
		if tap_one == 2:
			ConstantsValue.game_mode_change = true
			$UILayer.change_scene("res://UI/Game.tscn")
		else:
			ConstantsValue.showMessage("双击退出副本",2)
		yield(get_tree().create_timer(0.5),"timeout")
		tap_one = 0

#开始战斗
func _on_attrs4_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		start_check()
		#start_fight()

func start_fight():
	if choose_hero == null:
		ConstantsValue.showMessage("请选择挑战领主",1)
		return
	$CanvasLayer/HpUI/lv.text = "%s：%s" %[choose_hero,lineEdit.get_item_text(choose_lv)]
	setHero()
	setMoster()
	$CanvasLayer/ChooseUI.visible = false
	$CanvasLayer/HpUI.visible = true
	$CanvasLayer/hurt_bd.visible = true
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
		$Timer.stop()
		over(false)
	else:
		time_out -= 1
		$CanvasLayer/HpUI/time.text = "倒计时：%s秒" %time_out

func _on_start_fight_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		$CanvasLayer/HpUI/start_fight.visible = false
		get_tree().call_group("player_role","setRoleScript",moster_array,player_array)
		get_tree().call_group("moster_role","setRoleScript",player_array,moster_array)
		yield(get_tree().create_timer(0.2),"timeout")
		get_tree().call_group("player_role","start_fight")
		get_tree().call_group("moster_role","start_fight")
		get_tree().call_group("player_role","show_bar")
		$Timer.start()

func start_check():
	var http = GodotHttp.new()
	http.connect("http_res",self,"on_http")
	var query = JSON.print({
		"save_id":StorageData.get_player_state()["save_id"],
		"version":"115"
	})
	http.http_post("sign/boss_count",query)

func on_http(url,data):
	if data["data"].is_sign_gif:
		start_fight()
	else:
		ConstantsValue.showMessage("次数不足，无法挑战",2)
