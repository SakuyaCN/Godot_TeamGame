extends Node

var storage_data :Dictionary
var is_read_storage = false
# Called when the node enters the scene tree for the first time.
func _ready():
	_read_storage()
	get_player_inventory()
	get_player_equipment()
	get_player_state()
	get_all_team()
	get_team_state()
	
func _read_storage():
	var storage_data_file = File.new()
	var err = storage_data_file.open("user://Storages.json",File.READ)
	if err == OK:
		storage_data = JSON.parse(storage_data_file.get_as_text()).result
		is_read_storage = true
	storage_data_file.close()

func _save_storage():
	var storage_data_file = File.new()
	var err = storage_data_file.open("user://Storages.json",File.WRITE)
	storage_data_file.store_string(to_json(storage_data))
	storage_data_file.close()

#获取人物背包
func get_player_inventory():
	if not is_read_storage:
		_read_storage()
	if not storage_data.has("player_inventory"):
		storage_data["player_inventory"] = []
		_save_storage()
	return storage_data["player_inventory"]

#获取人物装备
func get_player_equipment():
	if not is_read_storage:
		_read_storage()
	if not storage_data.has("player_equipment"):
		storage_data["player_equipment"] = []
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

#获取队伍状态
func get_team_state():
	if not is_read_storage:
		_read_storage()
	if not storage_data.has("player_team"):
		storage_data["player_team"] = {
			"position1":null,
			"position2":null,
			"position3":null
		}
		_save_storage()
	return storage_data["player_team"]
