class_name HeroAttrBean

#基础属性
var max_hp :int#生命
var hp :int#生命
var atk:int#攻击
var mtk:int#魔力
var def:int#物免
var mdef:int#魔免
var speed:int#速度
var crit:int#暴击

#元素属性
var fire:int
var wind:int
var ice:int
var posion:int

#其他属性
var mp:int#法力值
var hold:int #招架
var hole_num:int#招架数值
var dodge:int #闪避
var mtk_pass:int #魔力穿透
var atk_pass:int #物理穿透
var atk_blood:int #物理吸血
var mtk_blood:int #魔力吸血
var atk_buff:int #攻击力提升比例
var mtk_buff:int #魔力提升比例
var hp_buff:int #生命提升比例
var true_hurt:int #真实伤害

#重载基础属性
func resetAttr(role_data):
	hp = role_data.attr.hp
	atk = role_data.attr.atk
	def = role_data.attr.def
	mdef = role_data.attr.mdef
	mtk = role_data.attr.mtk
	speed = role_data.attr.speed
	crit = role_data.attr.crit
	
	mp = 100
	levelAttr(role_data.lv)

func levelAttr(lv):
	hp += lv * 15                                                                                                                                                                                          
	atk += lv * 5
	mtk += lv * 5
	speed += lv * 3
	crit += lv * 3
	
#重载装备属性
func setEquAttrBean(role_data):
	resetAttr(role_data)
	#加载武器基础数据
	for equ in role_data["equ"]:
		var equ_data = StorageData.get_player_equipment()[role_data["equ"][equ]]
		#基础属性
		for base_attr_item in equ_data["base_attr"]:
			match base_attr_item.keys()[0]:
				"hp": hp += base_attr_item.values()[0]
				"atk": atk += base_attr_item.values()[0]
				"def": def += base_attr_item.values()[0]
				"mdef": mdef += base_attr_item.values()[0]
				"mtk": mtk += base_attr_item.values()[0]
				"speed": speed += base_attr_item.values()[0]
				"crit": crit += base_attr_item.values()[0]
		#元素属性
		for base_attr_item in equ_data["ys_attr"]:
			match base_attr_item.keys()[0]:
				"fire": fire += base_attr_item.values()[0]
				"wind": wind += base_attr_item.values()[0]
				"ice": ice += base_attr_item.values()[0]
				"posion": posion += base_attr_item.values()[0]
	loadJobAttr(role_data)
	loadOhterAttr()
	max_hp = hp

func loadJobAttr(role_data):
	match role_data.job:
		"黑袍法师":
			hp += (mtk / 10) as int
			mp += (mtk / 10) as int
		"无畏勇者":
			hp += 25 * role_data.lv
			atk += 15 * role_data.lv
		"不屈骑士":
			hp += 50 * role_data.lv
		"绝地武士":
			speed += 10 * role_data.lv
			crit += 10 * role_data.lv
			speed += (speed * 0.06) as int
		"致命拳手":
			hp += 15 * role_data.lv
			atk += 5 * role_data.lv
			speed += 5 * role_data.lv

func loadOhterAttr():
	if hp_buff>0:
		hp += (hp_buff/100 * hp) as int
	if atk_buff>0:
		atk += (atk_buff/100 * atk) as int
	if mtk_buff>0:
		mtk += (mtk_buff/100 * mtk) as int
