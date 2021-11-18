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
}

enum SkillHurtEnum{
	NUMBER = 0#直接数字伤害
	PT_ATTR_ON = 1#根据自身属性计算的百分比伤害
	PT_ATTR_OT = 2#根据敌人属性计算的百分比伤害
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
	return role_lv  * (role_lv * (role_lv * 2))+ 10
