extends Node

var fight_role_array = [] setget setFightRole#战斗对象
var do_atk_array = []#攻击对象数据
onready var hero_sprite:AnimatedSprite
onready var role_data#当前人物数据
onready var hero_attr:HeroAttrBean#当前人物属性
onready var is_in_atk = false

var is_moster = false
var atk_count #单词攻击数量

#初始化战斗脚本
func load_script(_is_moster):
	is_moster = _is_moster
	hero_sprite = get_parent().animatedSprite
	role_data = get_parent().role_data
	hero_attr = get_parent().hero_attr
	atk_count = role_data.atk_count

func setFightRole(f_r):
	do_atk_array.clear()
	fight_role_array = f_r
	for i in range(atk_count):
		if fight_role_array.size() > i:
			do_atk_array.append(fight_role_array[i])

#普攻触发
func do_atk():
	is_in_atk = true
	#设定人物攻击频率
	hero_sprite.frames.set_animation_speed("Atk",(hero_sprite.frames.get_animation_speed("Atk") + (hero_attr.speed / 100)))
	hero_sprite.play("Atk")

#_atk_data攻击者信息 _atk_attr攻击者属性 atk_type 攻击伤害类型
func do_hurt(_atk_data,_atk_attr:HeroAttrBean,atk_type):
	var hurt_num = 0
	match atk_type:
		0:hurt_num = _atk_attr.atk * (1 - (hero_attr.def/100.0))#物理伤害
		1:hurt_num = _atk_attr.mtk * (1 - (hero_attr.mdef/100.0))#魔力伤害
		2:hurt_num = _atk_attr.atk#真实伤害
	get_parent()._show_damage_label(hurt_num,atk_type)
	print("收到伤害:%s" %hurt_num)

#战斗信号
func _on_AnimatedSprite_animation_finished():
	if is_in_atk:
		for role in do_atk_array:
			role.fight_script.do_hurt(role_data,hero_attr,0)
