extends Node

var state_bean:SkillStateBean
var hero_attr:HeroAttrBean
var timer:Timer
var role:Node

func _ready():
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout",self,"_destroy")

func _create(_role:Node,_bean,_hero_attr:HeroAttrBean):
	state_bean = _bean
	hero_attr = _hero_attr
	role = _role
	addBuff()
	role.ui.addBuffImage(state_bean.state_img,state_bean.state_id,state_bean.state_time)
	timer.start(state_bean.state_time)

#BUFF移除
func _destroy():
	role.call_deferred("removeState",state_bean.state_id)
	if is_instance_valid(state_bean):
		get_tree().queue_delete(state_bean)

#触发BUFF效果
func addBuff():
	role.call_deferred("_show_damage_label",state_bean.state_name,Utils.HurtType.OTHER)
	role.call_deferred("addState",state_bean)
