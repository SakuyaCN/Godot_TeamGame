extends Node

func _ready():
	Console.add_command('addBuff', self, 'addBuff')\
		.register()
	Console.add_command('addState', self, 'addState')\
		.register()

func addBuff():
	var buff = load("res://Role/Skill/BaseState/Buff.gd").new()
	get_parent().skill_script.add_child(buff)
	var bean = SkillStateBean.new()
	bean._create({
		"state_id":1000,
		"state_name":"攻击力提升",
		"state_lv":1,
		"state_time":5,
		"state_type":"atk",
		"state_mold":Utils.BuffModeEnum.BUFF,
		"state_num":1000,
		"state_img":"res://Texture/skill/buff/1.png",
		"sate_over":false
	})
	buff._create(get_parent(),bean,get_parent().hero_attr)

func addState():
	var buff = load("res://Role/Skill/BaseState/HurtState.gd").new()
	get_parent().skill_script.add_child(buff)
	var bean = SkillStateBean.new()
	bean._create({
		"state_id":1001,
		"state_name":"虚弱",
		"state_lv":1,
		"state_time":5,
		"state_type":Utils.BuffStateEnum.WEAK,
		"state_mold":Utils.BuffModeEnum.STATE,
		"state_num":2,
		"state_img":"res://Texture/skill/buff/3.png",
		"sate_over":false#持续时间是否叠加
	})
	buff._create(get_parent(),bean,get_parent().hero_attr)
