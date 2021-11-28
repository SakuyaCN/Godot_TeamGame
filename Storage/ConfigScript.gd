extends Node

var config = ConfigFile.new()
var file_path = "user://settings_test2.cfg"

func _ready():
	var err = config.load(file_path)
	if err != OK:
		firstLoad()
	else:
		firstLoad()
	ConstantsValue.configSet()

func firstLoad():
	if not config.has_section_key("fight", "auto_fight"):
		config.set_value("fight", "auto_fight", false)
	if not config.has_section_key("fight", "fight_num"):
		config.set_value("fight", "fight_num", true)
	if not config.has_section_key("fight", "fight_array"):
		config.set_value("fight", "fight_array", [])
	if not config.has_section_key("setting", "audio"):
		config.set_value("setting", "audio", true)
	if not config.has_section_key("fight", "array_num"):
		config.set_value("fight", "array_num", 0)
	config.save(file_path)

func getNumberSetting(colum,value):
	var err = config.load(file_path)
	if err == OK:
		if not config.has_section_key(colum, value):
			return false
		else:
			return config.get_value(colum, value, 0)
	else:
		return false

func getBoolSetting(colum,value):
	var err = config.load(file_path)
	if err == OK:
		if not config.has_section_key(colum, value):
			return false
		else:
			return config.get_value(colum, value, false)
	else:
		return false

func setBoolSetting(colum,value,_bool):
	var err = config.load(file_path)
	if err == OK:
		config.set_value(colum, value, _bool)
		config.save(file_path)

func getArraySetting(colum,value):
	var err = config.load(file_path)
	if err == OK:
		if not config.has_section_key(colum, value):
			return false
		else:
			return config.get_value(colum, value, [])
	else:
		return false

func setValueSetting(colum,value,array):
	var err = config.load(file_path)
	if err == OK:
		config.set_value(colum, value, array)
		config.save(file_path)
