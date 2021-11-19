extends Node

var fight_role_array = [] setget setFightRole#战斗对象
var do_atk_array = []#攻击对象数据
onready var hero_sprite:AnimatedSprite
onready var effect_sprite:AnimatedSprite
onready var role_data#当前人物数据
onready var hero_attr:HeroAttrBean#当前人物属性
onready var is_in_atk = false #是否处于攻击动作

var is_alive = true#是否存活
var is_moster = false#是否为怪物
var is_blinding = false #是否为致盲状态
var is_weak = false #是否为虚弱状态
var atk_count #攻击数量
var state_array = {} #状态列表

func _ready():
	set_process(false)

func _process(_delta):
	if is_alive && is_in_atk:
		if is_VERTIGO():
			hero_sprite.play("Idle")
		else:
			hero_sprite.play("Atk")
		is_blinding = is_BLINDING()
		is_weak = is_WEAK()
		

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

#检查输出目标列表
func checkFightRole():
	do_atk_array.clear()
	for fight_role in fight_role_array:
		if do_atk_array.size() < atk_count && fight_role.fight_script.is_alive:
			do_atk_array.append(fight_role)

#设置战斗对象列表
func setFightRole(f_r):
	do_atk_array.clear()
	fight_role_array = f_r
	for i in range(atk_count):
		if fight_role_array.size() > i:
			do_atk_array.append(fight_role_array[i])

#检查当前状态列表
func checkState():
	if state_array.has(Utils.BuffStateEnum.VERTIGO):
		hero_sprite.play("Idle")

#普攻触发
func do_atk():
	#设定人物攻击频率
	hero_sprite.frames.set_animation_speed("Atk",(hero_sprite.frames.get_animation_speed("Atk") + (hero_attr.speed / 100.0)))
	#hero_sprite.play("Atk")
	is_in_atk = true
	set_process(true)

func do_stop():
	load_script(is_moster)
	set_process(false)

#_atk_data攻击者信息 _atk_attr攻击者属性 atk_type 攻击伤害类型 fight_script 攻击者脚本
func do_hurt(_atk_data,_atk_attr:HeroAttrBean,atk_type,fight_script:Node):
	#闪避触发
	if hero_attr.dodge > 0 && randf() < hero_attr.dodge / 100.0:
		get_parent()._show_damage_label("MISS",Utils.HurtType.MISS)
		return
	var hurt_num = 0
	match atk_type:
		Utils.HurtType.ATK:
			hurt_num = _atk_attr.atk * (1 - ((hero_attr.def - _atk_attr.atk_pass)/100.0))#物理伤害
			fight_script.atk_blood(hurt_num)
		Utils.HurtType.MTK:
			hurt_num = _atk_attr.mtk * (1 - ((hero_attr.mdef - _atk_attr.mtk_pass)/100.0))#魔力伤害
			fight_script.mtk_blood(hurt_num)
	if _atk_attr.true_hurt > 0:
		hurt_num += _atk_attr.true_hurt
	#格挡
	hurt_num = hold_hurt(_atk_attr,hurt_num)
	if crit_hurt(_atk_attr):
		hurt_num *= 1.5 + (_atk_attr.crit_buff / 100.0)
		atk_type = Utils.HurtType.CRIT
	if fight_script.is_weak:
		hurt_num *= 0.6
	hero_attr.updateNum("hp",-hurt_num)
	if hero_attr.hp <= 0:
		die()
	get_parent()._show_damage_label(hurt_num,atk_type)
	effect_sprite.visible = true
	effect_sprite.play("hit")

#直接数字伤害 number 伤害字 atk_type 攻击类型 _atk_attr 攻击者属性 is_COUTINUED是否连续
func do_number_hurt(number,atk_type,_atk_attr:HeroAttrBean,is_COUTINUED):
	var hurt_num = 0
	match atk_type:
		Utils.HurtType.ATK:
			hurt_num = number * (1 - ((hero_attr.def - _atk_attr.atk_pass)/100.0))#物理伤害
		Utils.HurtType.MTK:
			hurt_num = number * (1 - ((hero_attr.mdef - _atk_attr.mtk_pass)/100.0))#魔力伤害
		_:hurt_num = number
	hero_attr.updateNum("hp",-hurt_num)
	if hero_attr.hp <= 0:
		die()
	if is_COUTINUED:
		get_parent()._show_damage_label(hurt_num,Utils.HurtType.COUTINUED)
	else:
		get_parent()._show_skill_label(hurt_num)

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
			return false
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
		if is_blinding && randf() <= 0.5:
			get_parent()._show_damage_label("丢失目标",Utils.HurtType.OTHER)
			return
		for role in do_atk_array:
				role.fight_script.do_hurt(role_data,hero_attr,Utils.HurtType.ATK,self)

func is_VERTIGO():
	for item in state_array.values():
		if item is SkillStateBean && item.state_mold == Utils.BuffModeEnum.STATE && item.state_type == Utils.BuffStateEnum.VERTIGO:
			return true
	return false

func is_BLINDING():
	for item in state_array.values():
		if item is SkillStateBean && item.state_mold == Utils.BuffModeEnum.STATE && item.state_type == Utils.BuffStateEnum.BLINDING:
			return true
	return false
	
func is_WEAK():
	for item in state_array.values():
		if item is SkillStateBean && item.state_mold == Utils.BuffModeEnum.STATE && item.state_type == Utils.BuffStateEnum.WEAK:
			return true
	return false
