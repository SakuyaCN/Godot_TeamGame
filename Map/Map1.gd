extends Node2D

var new_dialog = null

var select_map
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_pressed(extra_arg_0):
	if new_dialog != null:
		new_dialog.queue_free()
		new_dialog = null
	select_map = extra_arg_0
	new_dialog = Dialogic.start('test') 
	new_dialog.connect("dialogic_signal", self, "dialog_listener")
	add_child(new_dialog)

func dialog_listener(string):
	match string:
		"change_map":
			change_map()
		"cancel":
			new_dialog.queue_free()
			new_dialog = null

func change_map():
	var map_index = str(StorageData.storage_data["player_state"]["map_index"])
	if StorageData.storage_data["player_state"]["map"][map_index]["now_map"] == select_map:
		ConstantsValue.showMessage("已经在这张地图了！",2)
	elif StorageData.storage_data["player_state"]["map"][map_index]["max_map"] < select_map:
		ConstantsValue.showMessage("未解锁当前地图！",2)
	else:
		StorageData.storage_data["player_state"]["map"][map_index]["now_map"] = select_map
		get_tree().call_group("game_main","obsChangeMap")
		get_parent().get_parent().close_map()
	new_dialog.queue_free()
	new_dialog = null
