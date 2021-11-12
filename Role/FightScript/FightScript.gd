extends Node

var fight_role_array = [] setget setFightRole#战斗对象
var do_atk_array = []#攻击对象数据
onready var hero_sprite:AnimatedSprite
onready var effect_sprite:AnimatedSprite
onready var role_data#当前人物数据
onready var hero_attr:HeroAttrBean#当前人物属性
onready var is_in_atk = false #是否处于攻击动作

var is_alive = true
var is_moster = false
var atk_count #攻击数量

#初始化战斗脚本
func load_script(_is_moster):
	is_alive = true
	fight_role_array.clear()
	do_atk_array.clear()
	is_in_atk = false
	is_moster = _is_moster
	effect_sprite = get_parent().effect_anim
	hero_sprite = get_parent().animatedSprite
	role_data = get_parent().role_data
	hero_attr = get_parent().hero_attr
	atk_count = role_data.atk_count

func checkFightRole():
	do_atk_array.clear()
	for fight_role in fight_role_array:
		if do_atk_array.size() < atk_count && fight_role.fight_script.is_alive:
			do_atk_array.append(fight_role)

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
	hero_sprite.frames.set_animation_speed("Atk",(hero_sprite.frames.get_animation_speed("Atk") + (hero_attr.speed / 100.0)))
	hero_sprite.play("Atk")

#_atk_data攻击者信息 _atk_attr攻击者属性 atk_type 攻击伤害类型 fight_script 攻击者脚本
func do_hurt(_atk_data,_atk_attr:HeroAttrBean,atk_type,fight_script:Node):
	#闪避触发
	if hero_attr.dodge > 0 && randf() < hero_attr.dodge / 100.0:
		get_parent()._show_damage_label("MISS",Utils.HurtType.MISS)
		return
	var hurt_num = 0
	match atk_type:
		0:
			hurt_num = _atk_attr.atk * (1 - ((hero_attr.def - _atk_attr.atk_pass)/100.0))#物理伤害
			fight_script.atk_blood(hurt_num)
		1:
			hurt_num = _atk_attr.mtk * (1 - ((hero_attr.mdef - _atk_attr.mtk_pass)/100.0))#魔力伤害
			fight_script.mtk_blood(hurt_num)
	if _atk_attr.true_hurt > 0:
		hurt_num += _atk_attr.true_hurt
	#格挡
	hurt_num = hold_hurt(_atk_attr,hurt_num)
	if crit_hurt(_atk_attr):
		hurt_num *= 1.5 + (_atk_attr.crit_buff / 100.0)
		atk_type = Utils.HurtType.CRIT
	hero_attr.hp -= hurt_num
	get_parent()._show_damage_label(hurt_num,atk_type)
	effect_sprite.visible = true
	effect_sprite.play("hit")
	if hero_attr.hp <= 0:
		die()

#格挡触发
func hold_hurt(_atk_attr:HeroAttrBean,num):
	if hero_attr.hold > 0 && randf() < hero_attr.hold / 100.0:
		var hold_num = hero_attr.hole_num - _atk_attr.hole_pass
		if hold_num > 0:
			get_parent()._show_damage_label(hold_num,Utils.HurtType.HOLD)
			if num - hold_num > 0:
				return (num - hold_num) as int
			else:
				return 0 
		else:
			return num
	else:
		return num

#暴击触发
func crit_hurt(_atk_attr:HeroAttrBean):
	if _atk_attr.crit > 0 && randf() <  _atk_attr.crit / 7000.0:
		if hero_attr.uncrit > 0 && randf() <  hero_attr.uncrit / 7000.0:
			print("暴击抵抗")
			return false
		print("触发暴击")
		return true
#人物死亡
func die():
	is_alive = false
	get_tree().call_group("game_main","checkWin")
	hero_sprite.play("Die")
	is_in_atk = false

#物理攻击吸血
func atk_blood(num):
	if hero_attr.atk_blood > 0:
		var blood = num * (hero_attr.atk_blood / 100.0)
		if hero_attr.hp + blood < hero_attr.max_hp:
			hero_attr.hp += blood
		else:
			hero_attr.hp = hero_attr.max_hp
		get_parent()._show_damage_label(blood,Utils.HurtType.BLOOD)

#魔力攻击吸血
func mtk_blood():
	pass

#战斗信号
func _on_AnimatedSprite_animation_finished():
	if is_in_atk:
		checkFightRole()

#战斗时每帧
func _on_AnimatedSprite_frame_changed():
	if is_in_atk && hero_sprite.animation == "Atk" && hero_sprite.frame == (hero_sprite.frames.get_frame_count("Atk") * 0.7) as int:
		for role in do_atk_array:
			role.fight_script.do_hurt(role_data,hero_attr,Utils.HurtType.ATK,self)
