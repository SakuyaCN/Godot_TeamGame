extends Node2D

var role = preload("res://Role/BaseRole.tscn")
var hero_size = 0
var load_hero_size = 0

var moster_size = 0
var load_moster_size = 0

var boss_time_out = 100#BOSS战倒计时
var locao_boss_time = 0
var is_join_over = false

var map_name #当前地图关卡名称
var player_map #当前地图下标
var is_map_boss #当前是否为地图boss
var moster_name #当前地图怪物名称

var is_next_change_map = false #是否需要切换地图
var chang_map_id #切换地图的ID
var is_need_reload = false #是否需要重新占位

onready var message_ui = get_parent().find_node("UILayer")
onready var moster_pos = $PositionMoster

onready var game_progress:TextureProgress
onready var game_progress_tv

onready var role_position = [
	$Position/PositionP1,
	$Position/PositionP2,
	$Position/PositionP3
]

var player_array = []

var moster_array = []

var is_flight = false#是否可以准备战斗

func _ready():
	locao_boss_time = boss_time_out
	game_progress = get_parent().find_node("UILayer").find_node("Control").find_node("MainUi").find_node("progress_hp")
	game_progress_tv =  get_parent().find_node("UILayer").find_node("Control").find_node("MainUi").find_node("progress_hp").find_node("label_hp")
	add_to_group("game_main")

#加载地图
func load_map():
	ConstantsValue.ui_layer.ui.main_ui.setTitle(StorageData.storage_data["player_state"]["now_map"]+1)
	player_map = StorageData.storage_data["player_state"]["now_map"]
	map_name = LocalData.map_data.keys()[player_map/10]
	var map_info = LocalData.map_data[map_name]
	game_progress.max_value = map_info["max_progress"]
	game_progress.value = 0
	game_progress_tv.text = "当前地图探索进度：%s "%game_progress.value +" / 总进度：%s" %game_progress.max_value

func changeRolePosition(_is_need_reload):
	$Timer.stop()
	if !is_flight:
		newRoleJoin()
	else:
		is_need_reload = _is_need_reload

#探索进度条更新
func mapProgress():
	if !is_flight && game_progress.value != game_progress.max_value:
		game_progress.value += 1
		game_progress_tv.text = "当前地图探索进度：%s "%game_progress.value +" / 总进度：%s" %game_progress.max_value
		if game_progress.value == game_progress.max_value:
			moster_met(true)
			ConstantsValue.showMessage("BOSS来袭！",3)
			return
		if game_progress.value as int % (5+randi()%20) == 0:
			moster_met(false)

func plus_size():
	load_hero_size +=1
	if load_hero_size == hero_size:
		if ConfigScript.getBoolSetting("store","first_join"):
			$Timer.start()
		else:
			var new_dialog = Dialogic.start('first')
			new_dialog.connect("dialogic_signal",self,"dialogic_single")
			add_child(new_dialog)

#首次进入开始游戏
func dialogic_single(string):
	match string:
		"next_start":
			ConfigScript.setBoolSetting("store","first_join",true)
			$Timer.start()
		"moster_met_first":
			pass

#搜索遇到敌人
func moster_met(_is_boss):
	is_flight = true
	if !ConfigScript.getBoolSetting("store","moster_met_first"):#首次遇到敌人提示
		var new_dialog = Dialogic.start('moster_met_first')
		new_dialog.connect("dialogic_signal",self,"dialogic_single")
		add_child(new_dialog)
		ConfigScript.setBoolSetting("store","moster_met_first",true)
	is_map_boss = _is_boss
	get_parent().px_bg.is_run = false
	get_tree().call_group("player_role","changeAnim","Idle")
	moster_join(_is_boss)
	ConstantsValue.game_layer.findTvShow(false)

#敌人进入
func moster_plus_size():
	load_moster_size +=1
	if load_moster_size == moster_size:
		start_fight()

#战斗开始信号
func start_fight():
	ConstantsValue.game_layer.fight_ui.UIchange(true)
	get_tree().call_group("player_role","show_bar")
	get_tree().call_group("moster_role","show_bar")
	if is_map_boss:
		$BossTimer.start()

func go_position():
	ConstantsValue.game_layer.findTvShow(true)
	player_array.clear()
	hero_size = 0
	load_hero_size = 0
	for pos in StorageData.player_state["team_position"].size():
		if StorageData.player_state["team_position"][pos] != null:
			hero_size += 1
			var new_hero = role.instance()
			player_array.append(new_hero)
			new_hero.setIndex(pos)
			role_position[pos].add_child(new_hero)
			new_hero.set_role(StorageData.team_data.get(StorageData.player_state["team_position"][pos]))
			new_hero.run2position(role_position[pos])
			yield(get_tree().create_timer(0.7),"timeout")

func _on_Timer_timeout():
	mapProgress()

#怪物进入
func moster_join(_is_boss):
	var map_info = LocalData.map_data[map_name]
	moster_name = map_info.moster
	if _is_boss:
		moster_name = map_info.boss
	var moster_info = LocalData.moster_data[moster_name]
	var moster_data = {
		"nickname":moster_name,
		"job":"moster",
		"lv":player_map+1,
		"atk_count":moster_info.atk_count,
		"attr":mosterAttr(moster_name),
		"equ":{},
		"skill":{},
		"node":moster_info
	}
	moster_size = map_info.moster_num
	moster_array.clear()
	for index in map_info.moster_num:
		var new_hero = role.instance()
		moster_array.append(new_hero)
		moster_pos.get_children()[index].add_child(new_hero)
		new_hero.set_role(moster_data.duplicate())
		new_hero.setIndex(index)
		new_hero.run2position(moster_pos.get_children()[index])
		yield(get_tree().create_timer(0.7),"timeout")
	get_tree().call_group("player_role","setRoleScript",moster_array,player_array)
	get_tree().call_group("moster_role","setRoleScript",player_array,moster_array)

func mosterAttr(_name):
	var attr = LocalData.map_data["all_attr"][_name]
	var new_attr = {}
	for item in attr:
		if item == "def" || item == "mdef" || item == "other":
			new_attr[item] = attr[item]
		else:
			new_attr[item] = attr[item]+ (attr[item] * (game_progress.value / game_progress.max_value) * (1+(player_map / 10.0))) as int
	return new_attr

#检查胜利方
func checkWin():
	var is_moster_win = true
	var is_player_win = true
	for moster in moster_array:
		if moster.fight_script.is_alive:
			is_player_win = false
	for player in player_array:
		if player.fight_script.is_alive:
			is_moster_win = false
	if is_player_win:
		isBossFIght()
		get_tree().call_group("player_role","fight_over")
		winGoods()#胜利奖励
		isBossMapWin()
		game_reset()
	if is_moster_win:
		isBossFIght()
		get_tree().call_group("moster_role","fight_over")
		ConstantsValue.ui_layer.fight_fail()
		game_progress.value = 0
		if is_map_boss:#地图boss战斗胜利解锁下一关
			game_progress.value = 0

#boss战胜利解锁新关卡
func isBossMapWin():
	if is_map_boss:#地图boss战斗胜利解锁下一关
		game_progress.value = 0
		if StorageData.storage_data["player_state"]["now_map"] == StorageData.storage_data["player_state"]["max_map"]:
			StorageData.storage_data["player_state"]["max_map"] += 1
			if StorageData.storage_data["player_state"]["max_map"] == 10 && !ConfigScript.getBoolSetting("store","first_new_hero"):#首次遇到敌人提示
				var new_dialog = Dialogic.start('first_new_hero')
				ConfigScript.setBoolSetting("store","first_new_hero",true)
				StorageData.AddGoodsNum([["小队招募令",1]])
				add_child(new_dialog)
			StorageData._save_storage()
			ConstantsValue.showMessage("解锁新的关卡！",2)

#是否为boss战斗
func isBossFIght():
	if !$BossTimer.is_stopped():
		$BossTimer.stop()
		locao_boss_time = boss_time_out

#战斗胜利获得奖励
func winGoods():
	var win_goods = LocalData.moster_data[moster_name].win_data
	var goods_array = []
	for item in win_goods.goods:
		if randf() <= item[3] / 100.0:
			goods_array.append([item[0],item[1] as int+randi() % item[2] as int])
	StorageData.AddGoodsNum(goods_array)
	if win_goods.other.has("exp"):
		for _role in player_array:
			var _exp = (1 + (player_map / 10.0)) * win_goods.other.exp
			_role.addExp(_exp as int)
	if win_goods.has("more"):
		if win_goods.more.has("equ"):
			if randf() <= win_goods.more.equ.dl / 100.0:
				var key_index = win_goods.more.equ["equ"][randi()%win_goods.more.equ.values().size()]
				var choose_data = LocalData.build_data["build_data"][win_goods.more.equ["type"]][str(key_index)]
				EquUtils.createNewEqu(choose_data,choose_data.type)

func obsChangeMap(_id):
	chang_map_id = _id
	if is_flight:
		is_next_change_map = true
		ConstantsValue.showMessage("战斗结束后将切换地图！",2)
	else:
		changeMap(chang_map_id)
	

func game_reset():
	yield(get_tree().create_timer(0.6),"timeout")
	if is_need_reload:
		newRoleJoin()
	ConstantsValue.game_layer.fight_ui.UIchange(false)
	moster_clear()
	get_tree().call_group("player_role","role_reset")
	get_parent().px_bg.is_run = true
	is_flight = false
	load_moster_size = 0
	ConstantsValue.game_layer.findTvShow(true)
	if is_next_change_map:
		is_next_change_map = false
		changeMap(chang_map_id)

func newRoleJoin():
	ConstantsValue.showMessage("新冒险者登场！",1)
	player_clear()
	go_position()
	is_need_reload = false

#更换地图
func changeMap(_id):
	StorageData.storage_data["player_state"]["now_map"] = _id
	#ConstantsValue.ui_layer.ui.main_ui.setTitle(StorageData.storage_data["player_state"]["now_map"]+1)
	StorageData._save_storage()
	load_map()
	game_reset()
	

func moster_clear():
	for ms in moster_array:
		if ms != null && ms:
			ms.queue_free()
	if $PositionMoster/PositionM1.get_children().size() > 0:
		$PositionMoster/PositionM1.get_children().clear()
	if $PositionMoster/PositionM2.get_children().size() > 0:
		$PositionMoster/PositionM2.get_children().clear()
	if $PositionMoster/PositionM3.get_children().size() > 0:
		$PositionMoster/PositionM3.get_children().clear()
	moster_array.clear()
		
func player_clear():
	for ms in player_array:
		if ms != null && ms:
			ms.queue_free()
	if $Position/PositionP1.get_children().size() > 0:
		$Position/PositionP1.get_children().clear()
	if $Position/PositionP2.get_children().size() > 0:
		$Position/PositionP2.get_children().clear()
	if $Position/PositionP3.get_children().size() > 0:
		$Position/PositionP3.get_children().clear()
	player_array.clear()

#boss战倒计时
func _on_BossTimer_timeout():
	locao_boss_time -= 1
	ConstantsValue.showMessage("BOSS战倒计时：%s" %locao_boss_time,2)
	if locao_boss_time == 0:
		$BossTimer.stop()
		locao_boss_time = boss_time_out
		get_tree().call_group("moster_role","fight_over")
		get_tree().call_group("player_role","fight_over")
		ConstantsValue.ui_layer.fight_fail()
		if is_map_boss:
			game_progress.value = 0
