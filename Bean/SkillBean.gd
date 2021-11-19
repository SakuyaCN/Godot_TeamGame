extends Node

class_name SkillEntity

var skill_id:int#技能id
var skill_name :String#技能名称
var skill_img:String#技能图片
var skill_lv:int#技能等级
var skill_info:String#技能介绍

var skill_start = [] #战前释放
var skill_ing = []#战斗时释放
var skill_end = []#战斗死亡释放

var myself:Node #发动技能的玩家
var ss_array:Node #技能脚本临时存放区域
var hero_attr:HeroAttrBean #玩家属性
var local_attr = {}#玩家战斗开始时属性拷贝
var myself_array = [] #自家队伍
var enemy_array = [] #敌人队伍

#装载技能
func loadSkill(skill_data):
	skill_id = skill_data["skill_id"]
	skill_name = skill_data["skill_name"]
	skill_img = skill_data["skill_img"]
	skill_lv = skill_data["skill_lv"]
	loadItemSkill(skill_data)

func loadRoleArray(_enemy_array,_myself_array,_myself,_ss_array):
	myself_array = _myself_array
	enemy_array = _enemy_array
	myself = _myself
	ss_array = _ss_array
	hero_attr = _myself.hero_attr
	local_attr = hero_attr.toDict().duplicate()
	hero_attr.connect("onAttrChange",self,"on_attr_change")

#当属性发生变化是触发
func on_attr_change(attr,num):
	for skill in skill_start:
		if skill is SkillItemBean:
			attrChange_dec(skill)

#战前准备技能释放
func skillStart():
	for skill in skill_start:
		if skill is SkillItemBean:
			decisionSkill(skill)
				
#战斗技能释放
func skillIng():
	for skill in skill_ing:
		if skill is SkillItemBean:
			decisionSkill(skill)

#死亡技能释放
func skillEnd():
	for skill in skill_end:
		if skill is SkillItemBean:
			decisionSkill(skill)

#判定释放技能
func decisionSkill(skill:SkillItemBean):
	match skill.item_odds_type:
		0:#百分比概率触发
			pos_dec(skill)
		1:#属性发生变化时触发
			attrChange_dec(skill)

#百分比判定
func pos_dec(skill):
	if skill.item_odds / 100.0 > randf():
		chooseRole(skill)

#当数值低于区间判断
func attrChange_dec(skill):
	var num = hero_attr.toDict()[skill.item_odds_attr]
	if num / local_attr[skill.item_odds_attr] < skill.item_odds_num / 100.0:
		chooseRole(skill)

#选择释放角色
func chooseRole(skill:SkillItemBean):
	for index in skill.item_role:
		if index > 0:
			if myself_array.size() > (index-1):
				doSkillItemScript(myself_array[index-1],skill)
		else:
			if enemy_array.size() > (index-1):
				doSkillItemScript(enemy_array[abs(index)-1],skill)

#运行技能附带脚本
func doSkillItemScript(role:Node,skill:SkillItemBean):
	var script = load(skill.item_script).new()
	script._create(role,myself,skill.scrpit_info)
#	if script is BaseState:
#	elif script is HurtSkill:

#装载脚本
func loadItemSkill(skill_data):
	if skill_data.has("skill_start"):
		for data in skill_data["skill_start"]:
			var item_bean = SkillItemBean.new()
			item_bean._create(data)
			skill_start.append(item_bean)
	if skill_data.has("skill_ing"):
		for data in skill_data["skill_ing"]:
			var item_bean = SkillItemBean.new()
			item_bean._create(data)
			skill_ing.append(item_bean)
	if skill_data.has("skill_end"):
		for data in skill_data["skill_end"]:
			var item_bean = SkillItemBean.new()
			item_bean._create(data)
			skill_end.append(item_bean)
