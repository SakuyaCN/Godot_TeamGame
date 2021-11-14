extends Node

class_name BaseState

var type
var num
var time
var hero_attr:HeroAttrBean
var timer:Timer

func _ready():
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout",self,"_destroy")

func _create(_type,_num,_time,_hero_attr:HeroAttrBean):
	type = _type
	num = _num
	time = _time
	hero_attr = _hero_attr
	addBuff()
	timer.start(_time)

func _destroy():
	get_tree().call_group("RoleUI","load_attr")

#触发BUFF效果
func addBuff():
	get_tree().call_group("RoleUI","load_attr")

