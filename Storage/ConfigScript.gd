extends Node

var config = ConfigFile.new()
var file_path = "user://settings_test.cfg"

func _ready():
	var err = config.load(file_path)
	if err == OK:
		if not config.has_section_key("fight", "auto_fight"):
			config.set_value("fight", "auto_fight", false)
		config.save(file_path)
	else:
		config.save(file_path)

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
