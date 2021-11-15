extends Node

class_name BaseState

var state_bean:SkillStateBean
var hero_attr:HeroAttrBean
var timer:Timer

func _ready():
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout",self,"_destroy")

func _create(_bean,_hero_attr:HeroAttrBean):
	state_bean = _bean
	hero_attr = _hero_attr
	addBuff()
	timer.start(state_bean.state_time)

func _destroy():
	get_tree().call_group("RoleUI","load_attr")
	if is_instance_valid(state_bean):
		get_tree().queue_delete(state_bean)

#触发BUFF效果
func addBuff():
	get_tree().call_group("RoleUI","load_attr")

