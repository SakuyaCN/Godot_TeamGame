extends Node

var moster_data
var map_data
#tags position 0 物品类型
#	quick ->可放入快捷栏类型 equ ->可放入装备栏类型 -> all 可放入任意位置

func _ready():
	var item_data_file = File.new()
	item_data_file.open("res://Storage/Moster.json",File.READ)
	moster_data = JSON.parse(item_data_file.get_as_text()).result
	item_data_file.close()
	load_map()

func load_map():
	var item_data_file = File.new()
	item_data_file.open("res://Storage/Map.json",File.READ)
	map_data = JSON.parse(item_data_file.get_as_text()).result
	item_data_file.close()
