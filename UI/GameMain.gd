extends Node2D


var role = preload("res://Role/BaseRole.tscn")
var hero_size = 0
var load_hero_size = 0

var moster_size = 0
var load_moster_size = 0

var map_name

onready var message_ui = get_parent().find_node("UILayer")
onready var moster_pos = $PositionMoster

onready var role_position = [
	$Position/PositionP1,
	$Position/PositionP2,
	$Position/PositionP3
]

var player_array = {
	"positionP1":null,
	"positionP2":null,
	"positionP3":null,
}

var moster_array = {
	"positionM1":null,
	"positionM2":null
}

var is_flight = false#是否可以准备战斗
var is_flighting = false#是否正在战斗

func _ready():
	add_to_group("game_main")

func load_map():
	var player_map = StorageData.storage_data["player_state"]["now_map"]
	map_name = LocalData.map_data.keys()[player_map/10]

func plus_size():
	load_hero_size +=1
	if load_hero_size == hero_size:
		$Timer.start()

func moster_plus_size():
	load_moster_size +=1
	if load_moster_size == moster_size:
		is_flighting = true
		start_fight()

func start_fight():
	get_tree().call_group("player_role","start_fight")
	get_tree().call_group("moster_role","start_fight")

func go_position():
	for pos in StorageData.player_state["team_position"].size():
		if StorageData.player_state["team_position"][pos] != null:
			hero_size += 1
			var new_hero = role.instance()
			new_hero.setIndex(pos)
			role_position[pos].add_child(new_hero)
			new_hero.set_role(StorageData.team_data.get(StorageData.player_state["team_position"][pos]))
			new_hero.run2position(role_position[pos])
			yield(get_tree().create_timer(0.7),"timeout")

func _on_Timer_timeout():
	if not is_flight and randi()%100 < 90:
		is_flight = true
		get_parent().px_bg.is_run = false
		get_tree().call_group("player_role","changeAnim","Idle")
		moster_join()

func moster_join():
	var moster_name = LocalData.map_data[map_name].moster
	var map_info = LocalData.map_data[map_name]
	var moster_info = LocalData.moster_data[moster_name]
	var moster_data = {
		"nickname":moster_name,
		"job":"moster",
		"attr":LocalData.map_data["all_attr"][StorageData.storage_data["player_state"]["now_map"]],
		"node":moster_info
	}
	moster_size = map_info.moster_num
	for index in map_info.moster_num:
		var new_hero = role.instance()
		moster_array["positionM%s"%(index+1)] = new_hero
		moster_pos.get_children()[index].add_child(new_hero)
		new_hero.set_role(moster_data)
		new_hero.setIndex(index)
		new_hero.run2position(moster_pos.get_children()[index])
