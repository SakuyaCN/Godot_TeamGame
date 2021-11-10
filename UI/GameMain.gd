extends Node2D

var role = preload("res://Role/BaseRole.tscn")
var hero_size = 0
var load_hero_size = 0

var moster_size = 0
var load_moster_size = 0

var map_name #当前地图关卡名称

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
	game_progress = get_parent().find_node("UILayer").find_node("Control").find_node("MainUi").find_node("progress_hp")
	game_progress_tv =  get_parent().find_node("UILayer").find_node("Control").find_node("MainUi").find_node("progress_hp").find_node("label_hp")
	add_to_group("game_main")

#加载地图
func load_map():
	var player_map = StorageData.storage_data["player_state"]["now_map"]
	map_name = LocalData.map_data.keys()[player_map/10]
	var map_info = LocalData.map_data[map_name]
	game_progress.max_value = map_info["max_progress"]
	game_progress.value = 0
	game_progress_tv.text = "当前地图探索进度：%s "%game_progress.value +" / 总进度：%s" %game_progress.max_value

#探索进度条更新
func mapProgress():
	if !is_flight && game_progress.value != 100:
		game_progress.value += 1
		game_progress_tv.text = "当前地图探索进度：%s "%game_progress.value +" / 总进度：%s" %game_progress.max_value
		if game_progress.value as int % 5 == 0:
			moster_met()

func plus_size():
	load_hero_size +=1
	if load_hero_size == hero_size:
		$Timer.start()

#搜索遇到敌人
func moster_met():
	is_flight = true
	get_parent().px_bg.is_run = false
	get_tree().call_group("player_role","changeAnim","Idle")
	moster_join()
	ConstantsValue.game_layer.findTvShow(false)

#敌人进入
func moster_plus_size():
	load_moster_size +=1
	if load_moster_size == moster_size:
		start_fight()

#战斗开始信号
func start_fight():
	ConstantsValue.game_layer.fight_ui.UIchange(true)
	get_tree().call_group("player_role","show_bar",moster_array)
	get_tree().call_group("moster_role","show_bar",player_array)

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

func moster_join():
	var map_info = LocalData.map_data[map_name]
	var moster_name = map_info.moster
	var moster_info = LocalData.moster_data[moster_name]
	var moster_data = {
		"nickname":moster_name,
		"job":"moster",
		"lv":5,
		"atk_count":moster_info.atk_count,
		"attr":LocalData.map_data["all_attr"][StorageData.storage_data["player_state"]["now_map"]],
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
		new_hero.set_role(moster_data)
		new_hero.setIndex(index)
		new_hero.run2position(moster_pos.get_children()[index])
		yield(get_tree().create_timer(0.7),"timeout")

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
		get_tree().call_group("player_role","fight_win")
		ConstantsValue.ui_layer.fight_win()
	if is_moster_win:
		get_tree().call_group("moster_role","fight_win")
		ConstantsValue.ui_layer.fight_fail()

func game_reset():
	moster_clear()
	get_tree().call_group("player_role","role_reset")
	get_parent().px_bg.is_run = true
	is_flight = false
	load_moster_size = 0
	ConstantsValue.game_layer.findTvShow(true)

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
		
