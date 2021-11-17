extends BaseState

var hero_attr:HeroAttrBean
var role:Node

func _ready():
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout",self,"_destroy")

func _create(_role:Node,_bean,_hero_attr:HeroAttrBean):
	._create(role,_bean,_hero_attr)
	hero_attr = _hero_attr
	role = _role
	addBuff()
	role.ui.addBuffImage(state_bean)
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
