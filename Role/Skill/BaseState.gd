extends Node

class_name BaseState

var timer:Timer
var state_bean:SkillStateBean

func _create(role:Node,_bean,_hero_attr:HeroAttrBean):
	state_bean = _bean
	set_meta("state_id",state_bean.state_id)
