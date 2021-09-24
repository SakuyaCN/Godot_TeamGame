extends Node

var moster_data#怪物数据
var map_data#地图数据

var all_data:Dictionary#所以物品存放的字典


func _ready():
	var item_data_file = File.new()
	item_data_file.open("res://Storage/Moster.json",File.READ)
	moster_data = JSON.parse(item_data_file.get_as_text()).result
	item_data_file.close()
	load_map()
	load_data()

func load_map():
	var item_data_file = File.new()
	item_data_file.open("res://Storage/Map.json",File.READ)
	map_data = JSON.parse(item_data_file.get_as_text()).result
	item_data_file.close()
	
func load_data():
	var item_data_file = File.new()
	item_data_file.open("res://Storage/Data.json",File.READ)
	all_data = JSON.parse(item_data_file.get_as_text()).result
	item_data_file.close()
