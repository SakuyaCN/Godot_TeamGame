extends Node

var state_bean:SkillStateBean
var hero_attr:HeroAttrBean
var timer:Timer

func _ready():
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout",self,"_destroy")

func _create(role:Node,_bean,_hero_attr:HeroAttrBean):
	state_bean = _bean
	hero_attr = _hero_attr
	addBuff()
	role.ui.addBuffImage(state_bean.state_img,state_bean.state_id,state_bean.state_time)
	timer.start(state_bean.state_time)

func _destroy():
	updateAttr(true)
	get_tree().call_group("RoleUI","load_attr")
	if is_instance_valid(state_bean):
		get_tree().queue_delete(state_bean)

#触发BUFF效果
func addBuff():
	updateAttr(false)
	get_tree().call_group("RoleUI","load_attr")


func updateAttr(is_over):
	var num = state_bean.state_num
	if state_bean.state_mold == Utils.BuffModeEnum.DEBUFF:
		num = 0 - num
	if is_over:
		num = 0 - num
	hero_attr.updateNum(state_bean.state_type,num)
