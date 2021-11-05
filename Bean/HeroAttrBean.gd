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

#重载基础属性
func resetAttr(role_data):
	hp = role_data.attr.hp
	atk = role_data.attr.atk
	def = role_data.attr.def
	mdef = role_data.attr.mdef
	mtk = role_data.attr.mtk
	speed = role_data.attr.speed
	crit = role_data.attr.crit

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
	max_hp = hp

