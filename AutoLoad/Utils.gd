extends Node2D

enum HurtType{
	OTHER = -1#自定义
	ATK = 0#伤害颜色 物理伤害
	MTK = 1#伤害颜色 魔力伤害
	TRUE = 2#伤害颜色 真实伤害
	BLOOD = 3#增益颜色 吸血
	MISS = 4#闪避
	HOLD = 5#格挡
	CRIT = 6#暴击
	COUTINUED = 7#持续伤害
	EXP = 8#经验
}

enum BuffModeEnum{
	BUFF = 0#正面状态
	DEBUFF = 1#负面状态
	STATE = 2#其他状态
}

enum BuffStateEnum{
	OTHER = -1#自定义
	VERTIGO = 0#眩晕
	BLINDING = 1#致盲
	COUTINUED = 2#持续类
	WEAK = 3#虚弱
	SJ = 4#重伤
	NOHURT = 5#无敌
}

enum SkillHurtEnum{
	NUMBER = 0#直接数字伤害
	PT_ATTR_ON = 1#根据自身属性计算的百分比伤害
	PT_ATTR_OT = 2#根据敌人属性计算的百分比伤害
}

enum SkillTypeEnum{
	ODDS = 0# 概率触发
	ATTR = 1#属性低于阈值触发
	ATK_ING = 2#战斗时普攻触发
	ATK_TIME = 3#战斗时每秒触发
}

const DOT = "▪"
const K1 = 3600
const K2 = 10

const K3 = 10
const K4 = 3600

const ATTR_POWER_ATK: float = 4.0
const ATTR_POWER_HP: float = 6.0

const ATTR_STR_HP: float = 15.0
const ATTR_STR_DEF: float = 5.0

const ATTR_AGI_SPEED: float = 2.0
const ATTR_AGI_CRIT: float = 3.0

const ATTR_SPI_MAG: float = 5.0
const ATTR_SPI_UNCRIT: float = 3.0
const ATTR_SPI_MAG_SUPER: float = 2.0

const ATTR_INTE_MAG_SUPER: float = 6.0
const ATTR_INTE_ATK: float = 2.0

const GEMS_ATK: int = 50
const GEMS_DEF: int = 100
const GEMS_HP: int = 200
const GEMS_SPEED: int = 20
const GEMS_MTK: int = 35
const GEMS_YS_ATK: int = 7
const GEMS_YS_DEF: int = 10
const GEMS_ATK_FIRE: int = 15
const GEMS_DEF_FIRE: int = 15
const GEMS_ATK_WATER: int = 15
const GEMS_DEF_WATER: int = 15
const GEMS_ATK_FLASH: int = 15
const GEMS_DEF_FLASH: int = 15
const GEMS_ATK_WIND: int = 15
const GEMS_DEF_WIND: int = 15
const GEMS_ATK_POISON: int = 15
const GEMS_DEF_POISON: int = 15

enum RoleWalkStatus{
	WALK,IDLE,ATK,DIE,WAIT_ATK,FB
}

enum WorldMode{
	NOR,YS
}

func _ready():
	pass

func get_select_string(sid):
	match sid:
		0:
			return "力量："
		1:
			return "体质："
		2:
			return "敏捷："
		3:
			return "精神："
		4:
			return "智力："
		5:
			return "幸运："
		6:
			return "锻造："
		7:
			return "建筑："
		8:
			return "耐力："
		9:
			return "管理："
			
func get_select_attr(sid):
	match sid:
		0:
			return "攻击"
		1:
			return "血量"
		2:
			return "魔力"
		3:
			return "法力"
		4:
			return "护甲"
		5:
			return "暴击"
		6:
			return "抗爆"
		7:
			return "速度"

func get_job_string(sid):
	match sid:
		0:
			return "勇者"
		1:
			return "黑袍"
		2:
			return "红帽"
		3:
			return "女武神"
			
func get_equ_bg(id):
	match id:
		0:
			return load("res://textrue/UI/equ_1.png")
		1:
			return load("res://textrue/UI/equ_2.png")
		2:
			return load("res://textrue/UI/equ_3.png")
		3:
			return load("res://textrue/UI/equ_4.png")
		4:
			return load("res://textrue/UI/equ_5.png")
		5:
			return load("res://textrue/UI/equ_6.png")

func get_adv_img(id):
	match id as int:
		1:
			return load("res://textrue/UI/lv1.png")
		2:
			return load("res://textrue/UI/lv2.png")
		3:
			return load("res://textrue/UI/lv3.png")
		4:
			return load("res://textrue/UI/lv4.png")
		5:
			return load("res://textrue/UI/lv5.png")
		6:
			return load("res://textrue/UI/lv6.png")
		7:
			return load("res://textrue/UI/lv6.png")

func get_adv_name(id):
	match id as int:
		1:
			return "黑铁级冒险者"
		2:
			return "青铜级冒险者"
		3:
			return "白银级冒险者"
		4:
			return "黄金级冒险者"
		5:
			return "白金级冒险者"
		6:
			return "黑金级冒险者"
		7:
			return "传说级冒险者"

func getPositionWithIndex(index):
	match index:
		0:return "前排"
		1:return "中卫"
		2:return "后排"
		-1:return "休战"

func getPositionWithName(_name):
	match _name:
		"前排":return 0
		"中卫":return 1
		"后排":return 2
		"休战":return -1

func getMapNameFormIndex(_index):
	match _index as int:
		0:return "普通地图"
		1:return "困难地图"
		2:return "地狱地图"
		3:return "神话地图"
		4:return "极限神话"
		5:return "传说之下"

func getMapName(_index):
	match _index as int:
		0:return "密林之森"
		1:return "古老荒漠"
		2:return "死寂之地"
		3:return "荒凉戈壁"
		4:return "自然边界"
		5:return "风暴雪域"

func findEquTzSize(role_data,tz):
	var size = 0
	for item in role_data["equ"]:
		if item != null && StorageData.get_player_equipment().has(role_data["equ"][item]):
			var _equ_data = StorageData.get_player_equipment()[role_data["equ"][item]]
			if _equ_data.has("tz") && _equ_data.tz.id == tz.id:
				size += 1
	return size

func get_gold_string(gold):
	if gold < 10000:
		return String(gold)
	elif 10000 <= gold && gold < 1000000:
		return String(stepify(gold as float/1000, 0.1))+"K"
	elif 1000000 <= gold && gold < 100000000:
		return String(stepify(gold as float/1000000, 0.1))+"M"
	elif 100000000 <= gold:
		return String(stepify(gold as float/100000000, 0.1))+"亿"

const K5 = 50
const K6 = 13500

func get_time_string(s):
	if s < 60:
		return str(s) + "秒"
	elif 60<=s && s<3600:
		return str((s/60) as int) +"分钟"
	elif s>=3600:
		return str(stepify(s as float/3600, 0.1)) +"小时"

func get_up_lv_exp(role_lv:int):
	if role_lv > 135:
		return ((role_lv * role_lv * (role_lv * 1.5)) * (1+ role_lv / 5.0) + 5) as int
	return ((role_lv * role_lv * (role_lv * 1.2)) * (0.2+ role_lv / 5.0) + 5) as int

#是否有队员达到等级要求
func is_lv_ok(_lv):
	var team = StorageData.get_all_team()
	for item in team:
		if team[item].lv >= _lv:
			return true
	return false

#找到技能
func findSkillFromAll(_id):
	return LocalData.skill_data[_id]

func setSkillFormAll(_id,_rid):
	for skill in StorageData.get_all_skill():
		if skill.id == _id:
			skill.role = _rid
			return

#人物是否穿戴相同技能
func findSkillFromPlayer(_role_data,_form_id):
	var count = 0
	for skill in _role_data["skill"]:
		if skill.form == _form_id:
			count += 1
	if count >= 1:
		return true
	return false

#为角色添加一个技能
func addSkillFormRole(_role_data,_skill_data):
	_role_data["skill"].append(_skill_data)
	_skill_data.role = _role_data.rid

#移除角色栏内的技能
func removeSkillFormRole(_role_data,_id):
	for skill in _role_data["skill"]:
		if skill.id == _id:
			_role_data["skill"].erase(skill)
			return

#移除所有技能中的指定id
func removeSkillFormAll(_id):
	for skill in StorageData.get_all_skill():
		if skill.id == _id:
			StorageData.get_all_skill().erase(skill)
			var info = LocalData.build_data["build_data"]["技能书"][skill.form]
			var num = (info.need[0][1] / 2) as int
			StorageData.AddGoodsNum([["技能手册",num]])
			ConstantsValue.showMessage("返还技能手册%s本"%num,2)
			return

func removeEquWithQy(_qy):
	var equ_data = StorageData.get_player_equipment()
	var qh = 0
	var delete_array = []
	for item in StorageData.get_player_equipment():
		if StorageData.get_player_equipment()[item].is_on == false && StorageData.get_player_equipment()[item].quality == _qy:
			delete_array.append(item)
	var num = delete_array.size()
	for key in delete_array:
		StorageData.get_player_equipment().erase(key)
	ConstantsValue.showMessage("已丢弃%d件%s装备"%[num,_qy],2)
	return num
	
