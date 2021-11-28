extends Control

var map_index = 0

func _ready():
	visible = false

func show_map():
	visible = true
	map_index = StorageData.get_player_state()["map_index"]
	$AnimationPlayer.play("show")
	$bg/title/Label.text = Utils.getMapNameFormIndex(map_index)
	
func close_map():
	$AnimationPlayer.play_backwards("show")
	yield($AnimationPlayer,"animation_finished")
	visible = false

func _on_TextureButton_pressed():
	close_map()


func _on_left_pressed():
	if map_index == 0:
		return 
	else:
		map_index-=1
		StorageData.get_player_state()["map_index"] = map_index
		reload()

func _on_right_pressed():
	if map_index == 3:
		return 
	else:
		if map_index < StorageData.storage_data["player_state"]["map_index_max"]:
			map_index+=1
			StorageData.get_player_state()["map_index"] = map_index
			reload()
		else:
			ConstantsValue.showMessage("尚未解锁新难度",1)

func reload():
	$bg/title/Label.text = Utils.getMapNameFormIndex(map_index)
	get_tree().call_group("game_main","obsChangeMap")
