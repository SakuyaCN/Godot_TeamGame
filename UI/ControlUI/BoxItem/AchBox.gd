extends Control
onready var ach_item = preload("res://UI/ItemUI/AchItem.tscn")
var local_data = null

func _init():
	var item_data_file = File.new()
	item_data_file.open_encrypted_with_pass("res://Storage/AchData.json",File.READ,"sakuya")
	local_data = JSON.parse(item_data_file.get_as_text()).result
	item_data_file.close()

func _ready():
	if !StorageData.get_player_state().has("ach_array"):
		StorageData.get_player_state()["ach_array"] = []
	if !StorageData.get_player_state().has("win_count"):
		StorageData.get_player_state()["win_count"] = 0
	$win.text = "当前已累计胜场：%s" %StorageData.get_player_state()["win_count"]
	if local_data != null:
		for item in local_data.map:
			var ins = ach_item.instance()
			$ScrollContainer/GridContainer.add_child(ins)
			ins.setData("map",item)
		for item in local_data.win:
			var ins = ach_item.instance()
			$ScrollContainer/GridContainer.add_child(ins)
			ins.setData("win",item)
