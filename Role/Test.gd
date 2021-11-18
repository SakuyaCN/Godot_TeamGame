extends Node

func _ready():
	Console.add_command('addBuff', self, 'addBuff')\
		.register()
	Console.add_command('addState', self, 'addState')\
		.register()
	Console.add_command('addPOI', self, 'addPOI')\
		.register()
	Console.add_command('dohurt', self, 'dohurt')\
		.register()
	Console.add_command('dohurt2', self, 'dohurt2')\
		.register()

func addBuff():
	var buff:Node = load("res://Role/Skill/BaseState/Buff.gd").new()
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
	buff._create(get_parent(),get_parent(),bean)

func addState():
	var buff = load("res://Role/Skill/BaseState/HurtState.gd").new()
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
		"state_over":false#持续时间是否叠加
	})
	buff._create(get_parent(),get_parent(),bean)

func addPOI():
	var buff = load("res://Role/Skill/BaseState/Countinued.gd").new()
	var bean = SkillStateBean.new()
	bean._create({
		"state_id":1002,
		"state_name":"中毒",
		"state_lv":1,
		"state_time":5,
		"state_type":Utils.BuffStateEnum.COUTINUED,
		"state_mold":Utils.BuffModeEnum.DEBUFF,
		"state_num":2,
		"state_img":"res://Texture/skill/buff/4.png",
		"state_over":false,#持续时间是否叠加
		"state_other":{
			"type":"ys",
			"hurt_type":"fire",
			"hurt_num":10
		}
	})
	buff._create(get_parent(),get_parent(),bean)

func dohurt():
	var buff = load("res://Role/Skill/HurtSkill.gd").new()
	var bean = SkillHurtBean.new()
	bean._create({
		"hurt_id":1002,
		"hurt_name":"火球术",
		"hurt_num":150,
		"hurt_type":Utils.HurtType.ATK,
		"hurt_attr":"atk",
		"hurt_mode":Utils.SkillHurtEnum.PT_ATTR_ON,
		"hurt_count":1
	})
	buff._create(get_parent().fight_script.do_atk_array[0],get_parent(),bean)

func dohurt2():
	var buff = load("res://Role/Skill/HurtSkill.gd").new()
	var bean = SkillHurtBean.new()
	bean._create({
		"hurt_id":1002,
		"hurt_name":"火球术一百连",
		"hurt_num":1111,
		"hurt_type":Utils.HurtType.ATK,
		"hurt_mode":Utils.SkillHurtEnum.NUMBER,
		"hurt_count":100,
		"hurt_count_time":0.01
	})
	buff._create(get_parent().fight_script.do_atk_array[0],get_parent(),bean)
