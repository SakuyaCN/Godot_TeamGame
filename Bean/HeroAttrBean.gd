class_name HeroAttrBean

signal onAttrChange(attr,num)

var _parant_node:Node

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
var shield:int#护盾
var exp_buff:int #经验增幅
var reflex:int#反射率
var skill_crit:int#技能暴击


#重载基础属性
func resetAttr(role_data):
	hp = role_data.attr.hp
	atk = role_data.attr.atk
	def = role_data.attr.def
	mdef = role_data.attr.mdef
	mtk = role_data.attr.mtk
	speed = role_data.attr.speed
	crit = role_data.attr.crit
	if role_data.attr.has("other"):
		for item in role_data.attr.other:
			updateNum(item,role_data.attr.other[item],false)
	else:
		levelAttr(role_data.lv)
	mp = 100

func levelAttr(lv):
	hp += lv * 35                                                                                                                                                                                    
	atk += lv * 10
	mtk += lv * 10
	speed += lv * 10
	crit += lv * 10
	
#重载装备属性
func setEquAttrBean(role_data):
	resetAttr(role_data)
	#加载武器基础数据
	for equ in role_data["equ"]:
		if StorageData.get_player_equipment().has(str(role_data["equ"][equ])):
			var equ_data = StorageData.get_player_equipment()[str(role_data["equ"][equ])]
			if equ_data != null:
				for base_attr_item in equ_data["base_attr"]:#基础属性
					updateNum(base_attr_item.keys()[0],base_attr_item.values()[0],false)
				for base_attr_item in equ_data["seal"]:#基础属性
					updateNum(base_attr_item.keys()[0],base_attr_item.values()[0],false)
				for base_attr_item in equ_data["ys_attr"]:#元素属性
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
			hp += ((mtk / 10.0) * 5) as int
			speed += (mtk / 10.0) as int
			mtk_pass += 5
		"无畏勇者":
			hp += 20 * role_data.lv
			atk += 5 * role_data.lv
			atk_blood += 5
		"不屈骑士":
			hp += 35 * role_data.lv
			hp += (hp * 0.1) as int
		"绝地武士":
			speed += 25 * role_data.lv
			crit += 25 * role_data.lv
			crit_buff += 50
			speed += (speed * 0.06) as int
		"致命拳手":
			hp += 25 * role_data.lv
			atk += 10 * role_data.lv
			speed += 10 * role_data.lv
			atk += (atk * 0.03) as int
		"战地女神":
			hp += 15 * role_data.lv
			atk += 10 * role_data.lv
			mtk += 5 * role_data.lv
			mtk += (atk * 0.05) as int
		_:
			hp += 20 * role_data.lv
			atk += 5 * role_data.lv
			mtk += 5 * role_data.lv
			speed += 5 * role_data.lv
			crit += 5 * role_data.lv

func loadOhterAttr():
	if hp_buff>0:
		hp += (hp_buff/100.0 * hp) as int
	if atk_buff>0:
		atk += (atk_buff/100.0 * atk) as int
	if mtk_buff>0:
		mtk += (mtk_buff/100.0 * mtk) as int

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
		"crit_buff" : crit_buff,
		"shield" : shield,
		"exp_buff":exp_buff,
		"reflex":reflex,
		"skill_crit":skill_crit
	}

func updateNum(attr,num,is_emit = true,is_buff = false):
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
		"shield" : shield += num
		"exp_buff":exp_buff+=num
		"reflex":reflex+=num
		"skill_crit":skill_crit += num
	if dodge > 30:
		dodge = 30
	if is_buff && attr == "hp":
		max_hp += num
		if _parant_node != null:
			_parant_node.call_deferred("reloadHpBar")
	if attr == "shield":
		if _parant_node != null:
			_parant_node.call_deferred("reloadHpBar")
	if is_buff && attr == "speed":
		if _parant_node != null:
			_parant_node.call_deferred("reloadHpBar")
	if is_emit:
		emit_signal("onAttrChange",attr,num)

func toBean(dict):
	max_hp = dict.max_hp
	hp = dict.hp
	atk = dict.atk
	mtk = dict.mtk
	def = dict.def
	mdef = dict.mdef
	speed = dict.speed
	crit = dict.crit
	fire = dict.fire
	wind = dict.wind
	ice = dict.ice
	posion = dict.posion
	uncrit = dict.uncrit
	mp = dict.mp
	hold = dict.hold
	hole_num = dict.hole_num
	dodge = dict.dodge
	hole_pass = dict.hole_pass
	mtk_pass = dict.mtk_pass
	atk_pass = dict.atk_pass
	atk_blood = dict.atk_blood
	mtk_blood = dict.mtk_blood
	atk_buff = dict.atk_buff
	mtk_buff = dict.mtk_buff
	hp_buff = dict.hp_buff
	true_hurt = dict.true_hurt
	hurt_buff = dict.hurt_buff
	crit_buff = dict.crit_buff
	shield = dict.shield
	exp_buff= dict.exp_buff
	reflex= dict.reflex
	skill_crit= dict.skill_crit
