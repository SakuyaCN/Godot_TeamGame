extends Node

var storage_data :Dictionary
var is_read_storage = false

var team_data :Dictionary
var player_state:Dictionary

func _ready():
	_read_storage()
	get_player_inventory()
	get_player_equipment()
	get_player_state()
	get_all_team()
	get_all_skill()
	reloadData()

func reloadData():
	team_data = storage_data["team"]
	player_state = storage_data["player_state"]
	
func _read_storage():
	var storage_data_file = File.new()
	var err = storage_data_file.open("user://Storages.json",File.READ)
	if err == OK:
		storage_data = JSON.parse(storage_data_file.get_as_text()).result
		is_read_storage = true
	storage_data_file.close()

func _save_storage():
	var storage_data_file = File.new()
	var _err = storage_data_file.open("user://Storages.json",File.WRITE)
	storage_data_file.store_string(to_json(storage_data))
	storage_data_file.close()

#获取人物背包
func get_player_inventory():
	if not is_read_storage:
		_read_storage()
	if not storage_data.has("player_inventory"):
		storage_data["player_inventory"] = {}
		_save_storage()
	return storage_data["player_inventory"]

#获取人物装备
func get_player_equipment():
	if not is_read_storage:
		_read_storage()
	if not storage_data.has("player_equipment"):
		storage_data["player_equipment"] = {}
		_save_storage()
	return storage_data["player_equipment"]

#获取人物状态
func get_player_state():
	if not is_read_storage:
		_read_storage()
	if not storage_data.has("player_state"):
		storage_data["player_state"] = {}
		_save_storage()
	return storage_data["player_state"]

#获取小队所有成员
func get_all_team():
	if not is_read_storage:
		_read_storage()
	if not storage_data.has("team"):
		storage_data["team"] = {}
		_save_storage()
	return storage_data["team"]

#获取已获取技能
func get_all_skill():
	if not is_read_storage:
		_read_storage()
	if not storage_data.has("skill"):
		storage_data["skill"] = []
		_save_storage()
	return storage_data["skill"]

#刷新人物装备背包
func reloadEquUI():
	get_tree().call_group("PartyUI","loadAllEqu")

#添加装备至人物背包
func addEqutoBag(equData):
	get_player_equipment()[equData.id] = equData
	StorageData._save_storage()
	reloadEquUI()

#检测背包道具是充足
func checkGoodsNum(array):
	var is_true = true #是否充足
	for item in array:
		if !get_player_inventory().has(item[0]):
			return false
		elif get_player_inventory()[item[0]] < item[1]:
			is_true = false
	return is_true

#为背包添加道具
func AddGoodsNum(array):
	for item in array:
		if get_player_inventory().has(item[0]) && item[1] > 0:
			get_player_inventory()[item[0]] += item[1]
		else:
			get_player_inventory()[item[0]] = item[1]
	_save_storage()

#使用背包道具
func UseGoodsNum(array):
	if checkGoodsNum(array):
		for item in array:
			if get_player_inventory().has(item[0]) && item[1] > 0:
				get_player_inventory()[item[0]] -= item[1]
				if get_player_inventory()[item[0]] == 0:
					get_player_inventory().erase(item[0])
		_save_storage()
		return true
	else:
		ConstantsValue.ui_layer.showMessage("背包道具不足！",1)
		return false
