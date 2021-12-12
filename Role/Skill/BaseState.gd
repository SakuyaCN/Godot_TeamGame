extends Node

class_name BaseState

var timer:Timer
var state_bean:SkillStateBean#状态详细实体
var role:Node#获得状态的角色
var who:Node #施加状态的角色
var hero_attr:HeroAttrBean#获得状态角色的属性

var last_time = 0#倒计时

func _ready():
	set_process(false)
	set_physics_process(false)
	pass

func _create(_role,_who,_bean):
	timer = Timer.new()
	timer.wait_time = 1
	timer.connect("timeout",self,"time_out")
	add_child(timer)
	who = _who
	state_bean = _bean
	role = _role
	hero_attr = _role.hero_attr
	name = state_bean.state_id
	last_time = state_bean.state_time
	role.call_deferred("addState",state_bean,self)
	if role.ui != null:
		role.ui.addBuffImage(state_bean)
	yield(timer,"tree_entered")
	timer.start()
	addBuff()

func addBuff():
	pass

#叠加模式 重置时间
func reset():
	timer.disconnect("timeout",self,"time_out")
	timer.stop()
	timer.connect("timeout",self,"time_out")
	last_time = state_bean.state_time
	timer.start()

#叠加模式 叠加时间
func addTime():
	timer.disconnect("timeout",self,"time_out")
	timer.stop()
	timer.connect("timeout",self,"time_out")
	last_time += state_bean.state_time
	timer.start()

func _destroy():
	pass

func time_out():
	if !role.fight_script.is_alive:
		_destroy()
		queue_free()
		return
	time_tick()
	last_time -= 1
	if last_time <= 0:
		_destroy()
		queue_free()

func time_tick():
	pass
