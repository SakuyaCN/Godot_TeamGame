extends Node

var skill_id:String#技能id
var skill_name :String#技能名称
var skill_img:String#技能图片
var skill_lv:int#技能等级

var skill_start = [] #战前释放
var skill_ing = []#战斗时释放

#装载技能
func loadSkill(skill_data):
	skill_id = skill_data["skill_id"]
	skill_name = skill_data["skill_name"]
	skill_img = skill_data["skill_img"]
	skill_lv = skill_data["skill_lv"]
	skill_start = skill_data["skill_start"]
	skill_ing = skill_data["skill_ing"]

	skillStart()

#战前准备技能释放
func skillStart():
	pass

#战前准备技能释放
func skillIng():
	pass
