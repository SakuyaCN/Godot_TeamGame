class_name HeroAttrBean

signal onAttrChange(attr,num)

#基础属性
var max_hp :int#生命
var hp:int#生命
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
var uncrit:int #抗暴击率
var mp:int#法力值
var hold:int #格挡率
var hole_num:int#格挡数值
var dodge:int #闪避
var hole_pass:int #格挡穿透
var mtk_pass:int #魔力穿透
var atk_pass:int #物理穿透
var atk_blood:int #物理吸血
var mtk_blood:int #魔力吸血
var atk_buff:int #攻击力提升比例
var mtk_buff:int #魔力提升比例
var hp_buff:int #生命提升比例
var true_hurt:int #真实伤害
var hurt_buff:int #伤害加成比
var crit_buff:int #暴伤加成比

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
	atk += lv * 2
	mtk += lv * 2
	speed += lv * 2
	crit += lv * 2
	
#重载装备属性
func setEquAttrBean(role_data):
	resetAttr(role_data)
	#加载武器基础数据
	for equ in role_data["equ"]:
		var equ_data = StorageData.get_player_equipment()[str(role_data["equ"][equ])]
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
				"mp": mp += base_attr_item.values()[0]
				"hold": hold += base_attr_item.values()[0]
				"hole_num": hole_num += base_attr_item.values()[0]
				"dodge": dodge += base_attr_item.values()[0]
				"hole_pass": hole_pass += base_attr_item.values()[0]
				"mtk_pass": mtk_pass += base_attr_item.values()[0]
				"atk_pass": atk_pass += base_attr_item.values()[0]
				"atk_blood": atk_blood += base_attr_item.values()[0]
				"mtk_blood": mtk_blood += base_attr_item.values()[0]
				"atk_buff": atk_buff += base_attr_item.values()[0]
				"mtk_buff": mtk_buff += base_attr_item.values()[0]
				"hp_buff": hp_buff += base_attr_item.values()[0]
				"true_hurt": true_hurt += base_attr_item.values()[0]
				"uncrit": uncrit += base_attr_item.values()[0]
				"hurt_buff": uncrit += base_attr_item.values()[0]
				"crit_buff" :crit_buff += base_attr_item.values()[0]
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

#装载职业特性
func loadJobAttr(role_data):
	match role_data.job:
		"黑袍法师":
			hp += (mtk / 10.0) as int
			mp += (mtk / 10.0) as int
		"无畏勇者":
			hp += 20 * role_data.lv
			atk += 5 * role_data.lv
			atk_blood += 3
		"不屈骑士":
			hp += 35 * role_data.lv
		"绝地武士":
			speed += 15 * role_data.lv
			crit += 15 * role_data.lv
			crit_buff += 35
			speed += (speed * 0.06) as int
		"致命拳手":
			hp += 16 * role_data.lv
			atk += 6 * role_data.lv
			speed += 6 * role_data.lv
		_:
			hp += 10 * role_data.lv
			atk += 10 * role_data.lv
			mtk += 10 * role_data.lv
			speed += 5 * role_data.lv
			crit += 5 * role_data.lv

func loadOhterAttr():
	if hp_buff>0:
		hp += (hp_buff/100.0 * hp) as int
	if atk_buff>0:
		atk += (atk_buff/100.0 * atk) as int
	if mtk_buff>0:
		mtk += (mtk_buff/100.0 * mtk) as int

func copy(_attr:HeroAttrBean):
	max_hp = _attr.max_hp
	hp = _attr.hp
	atk = _attr.atk
	mtk = _attr.mtk
	def = _attr.def
	mdef = _attr.mdef
	speed = _attr.speed
	crit = _attr.crit
	fire = _attr.fire
	wind = _attr.wind
	ice = _attr.ice
	posion = _attr.posion
	uncrit = _attr.uncrit
	mp = _attr.mp
	hold = _attr.hold
	hole_num = _attr.hole_num
	dodge = _attr.dodge
	hole_pass = _attr.hole_pass
	mtk_pass = _attr.mtk_pass
	atk_pass = _attr.atk_pass
	atk_blood = _attr.atk_blood
	mtk_blood = _attr.mtk_blood
	atk_buff = _attr.atk_buff
	mtk_buff = _attr.mtk_buff
	hp_buff = _attr.hp_buff
	true_hurt = _attr.true_hurt
	hurt_buff = _attr.hurt_buff
	crit_buff = _attr.crit_buff

func toDict():
	return {
		"max_hp" : max_hp,
		"hp" : hp,
		"atk" : atk,
		"mtk" : mtk,
		"def" : def,
		"mdef" : mdef,
		"speed" : speed,
		"crit" : crit,
		"fire" : fire,
		"wind" : wind,
		"ice" : ice,
		"posion" : posion,
		"uncrit" : uncrit,
		"mp" : mp,
		"hold" : hold,
		"hole_num" : hole_num,
		"dodge" : dodge,
		"hole_pass" : hole_pass,
		"mtk_pass" : mtk_pass,
		"atk_pass" : atk_pass,
		"atk_blood" : atk_blood,
		"mtk_blood" : mtk_blood,
		"atk_buff" : atk_buff,
		"mtk_buff" : mtk_buff,
		"hp_buff" : hp_buff,
		"true_hurt" : true_hurt,
		"hurt_buff" : hurt_buff,
		"crit_buff" : crit_buff
	}

func updateNum(attr,num):
	match attr:
		"max_hp" : max_hp += num
		"hp" : hp += num
		"atk" : atk += num
		"mtk" : mtk += num
		"def" : def += num
		"mdef" : mdef += num
		"speed" : speed += num
		"crit" : crit += num
		"fire" : fire += num
		"wind" : wind += num
		"ice" : ice += num
		"posion" : posion += num
		"uncrit" : uncrit += num
		"mp" : mp += num
		"hold" : hold += num
		"hole_num" : hole_num += num
		"dodge" : dodge += num
		"hole_pass" : hole_pass += num
		"mtk_pass" : mtk_pass += num
		"atk_pass" : atk_pass += num
		"atk_blood" : atk_blood += num
		"mtk_blood" : mtk_blood += num
		"atk_buff" : atk_buff += num
		"mtk_buff" : mtk_buff += num
		"hp_buff" : hp_buff += num
		"true_hurt" : true_hurt += num
		"hurt_buff" : hurt_buff += num
		"crit_buff" : crit_buff += num
	emit_signal("onAttrChange",attr,num)
