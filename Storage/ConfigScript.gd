extends Node

var config = ConfigFile.new()

func _ready():
	var err = config.load("user://settings.cfg")
	if err == OK:
		if not config.has_section_key("fight", "auto_fight"):
			config.set_value("fight", "auto_fight", false)
		config.save("user://settings.cfg")
	else:
		config.save("user://settings.cfg")

func getBoolSetting(colum,value):
	var err = config.load("user://settings.cfg")
	if err == OK:
		if not config.has_section_key(colum, value):
			return false
		else:
			return config.get_value(colum, value, false)
	else:
		return false

func setBoolSetting(colum,value,_bool):
	var err = config.load("user://settings.cfg")
	if err == OK:
		config.set_value(colum, value, _bool)
		config.save("user://settings.cfg")
