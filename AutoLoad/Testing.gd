extends Node

var time:Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	http()
	time = Timer.new()
	time.connect("timeout",self,"http")
	time.autostart = true
	time.one_shot = false
	add_child(time)
	time.start(180)

func http():
	if StorageData.storage_data != null:
		var http = GodotHttp.new()
		var data = JSON.print(get_data())
		http.http_post("testing",data)

func get_data():
	var uid = ConstantsValue.user_info.user_id
	if uid != null:
		uid = ConstantsValue.user_info.user_id
	else:
		uid = ""
	var user_data = {
		"uuid":OS.get_unique_id(),
		"save_id":StorageData.get_player_state()["save_id"],
		"user_id":uid,
		"goods":JSON.print(StorageData.get_player_inventory()),
		"gold":StorageData.get_player_state()["gold"]
	}
	return user_data
