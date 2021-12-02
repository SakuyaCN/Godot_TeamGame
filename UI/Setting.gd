extends Control

var is_first = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$NinePatchRect/bgm.pressed = ConfigScript.getBoolSetting("setting","audio")
	$NinePatchRect/auto_fight.pressed = ConfigScript.getBoolSetting("fight","auto_fight")
	$NinePatchRect/fight_num.pressed = ConfigScript.getBoolSetting("fight","fight_num")
	$NinePatchRect/equ_c.pressed = ConstantsValue.fight_array.has("C级")
	$NinePatchRect/equ_b.pressed = ConstantsValue.fight_array.has("B级")
	$NinePatchRect/equ_a.pressed = ConstantsValue.fight_array.has("A级")
	$NinePatchRect/equ_s.pressed = ConstantsValue.fight_array.has("S级")
	$NinePatchRect/SpinBox.value = ConfigScript.getNumberSetting("fight","array_num")
	is_first = true

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		queue_free()

#bgm
func _on_bgm_toggled(button_pressed):
	ConfigScript.setBoolSetting("setting","audio",button_pressed)
	if is_first:
		get_tree().call_group("Game","isPlayMusic")

#自动战斗
func _on_auto_fight_toggled(button_pressed):
	ConfigScript.setBoolSetting("fight","auto_fight",button_pressed)

func _on_fight_num_toggled(button_pressed):
	ConfigScript.setBoolSetting("fight","fight_num",button_pressed)
	ConstantsValue.updateFightNum()

func _on_equ_toggled(button_pressed, extra_arg_0):
	if is_first:
		if ConstantsValue.fight_array.has(extra_arg_0):
			ConstantsValue.fight_array.erase(extra_arg_0)
		else:
			ConstantsValue.fight_array.append(extra_arg_0)
		ConfigScript.setValueSetting("fight","fight_array",ConstantsValue.fight_array)
		ConstantsValue.configSet()

#丢弃等级
func _on_SpinBox_value_changed(value):
	ConfigScript.setValueSetting("fight","array_num",value)
	ConstantsValue.array_num = value

func _on_Button_pressed():
	get_tree().quit(0)

func _on_Button2_pressed():
	var http = GodotHttp.new()
	http.connect("http_res",self,"on_http")
	var query = JSON.print({
		"uuid":OS.get_unique_id(),
		"save_id":StorageData.get_player_state()["save_id"],
		"save_json":to_json(StorageData.storage_data)
	})
	http.http_post("storage",query)

func on_http(url,data):
	pass
