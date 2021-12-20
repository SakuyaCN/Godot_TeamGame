extends Control

func _ready():
	reload()

func reload():
	if StorageData.get_player_state().has("seal_return_lv"):
		$exp.text = "当前刻印收集杯返还率："+str(StorageData.get_player_state().seal_return_lv * 5) +"%"
		$gold.text = "需要金币*%s" %getGold()
	else:
		$exp.text = "当前刻印收集杯返还率：0%"

func _on_Button_pressed():
	if StorageData.get_player_state().seal_return_lv >= 10:
		ConstantsValue.showMessage("刻印杯最高返还率为50%",2)
		return
	if StorageData.get_player_state()["gold"] >= getGold():
		StorageData.get_player_state()["gold"] -= getGold()
		StorageData.get_player_state().seal_return_lv += 1
		StorageData._save_storage()
		reload()
	else:
		ConstantsValue.showMessage("金币不足！",2)

func getGold():
	var gold = 100
	gold += (StorageData.get_player_state().seal_return_lv * StorageData.get_player_state().seal_return_lv * 120)
	return gold
