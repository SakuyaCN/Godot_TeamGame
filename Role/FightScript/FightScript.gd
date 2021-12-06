extends Node

var fight_role_array = [] setget setFightRole#战斗对象
var do_atk_array = []#攻击对象数据
onready var hero_sprite:AnimatedSprite
onready var effect_sprite:AnimatedSprite
onready var role_data#当前人物数据
onready var hero_attr:HeroAttrBean#当前人物属性
onready var is_in_atk = false #是否处于攻击动作

var speed_temp = 0
var is_alive = true#是否存活
var is_moster = false#是否为怪物
var is_blinding = false #是否为致盲状态
var is_weak = false #是否为虚弱状态
var is_sj = false #是否为重伤
var is_nohurt =false
var atk_count #攻击数量
var state_array = {} #状态列表

var atk_mode = Utils.HurtType.ATK #普攻攻击类型

signal onAtkOver()#普攻结束信号

func _ready():
	pass

func _on_Timer_timeout():
	if is_alive && is_in_atk:
		if is_VERTIGO():
			if hero_sprite.animation != "Idle":
				hero_sprite.animation = "Idle"
		else:
			if hero_sprite.animation != "Atk":
				hero_sprite.animation = "Atk"
		is_blinding = is_BLINDING()
		is_weak = is_WEAK()
		is_sj = is_SJ()
		is_nohurt = is_NOHURT()

#初始化战斗脚本
func load_script(_is_moster):
	is_alive = true
	state_array.clear()
	fight_role_array.clear()
	do_atk_array.clear()
	is_in_atk = false
	is_moster = _is_moster
	effect_sprite = get_parent().effect_anim
	hero_sprite = get_parent().animatedSprite
	role_data = get_parent().role_data
	hero_attr = get_parent().hero_attr
	atk_count = role_data.atk_count
	is_blinding = false
	is_weak = false
	if speed_temp == 0:
		speed_temp = hero_sprite.frames.get_animation_speed("Atk") 

#检查输出目标列表
func checkFightRole():
	hero_sprite.frames.set_animation_speed("Atk",speed_temp + (hero_attr.speed / 120.0))
	do_atk_array.clear()
	for fight_role in fight_role_array:
		if fight_role != null:
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
	hero_sprite.frames.set_animation_speed("Atk",speed_temp + (hero_attr.speed / 120.0))
	is_in_atk = true
	$Timer.start()

func do_stop():
	load_script(is_moster)
	$Timer.stop()

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
	#伤害提升
	if _atk_attr.hurt_buff > 0:
		hurt_num += hurt_num * (_atk_attr.hurt_buff / 100.0)
	#真伤
	if _atk_attr.true_hurt > 0:
		hurt_num += _atk_attr.true_hurt
	#格挡
	hurt_num = hold_hurt(_atk_attr,hurt_num)
	if crit_hurt(_atk_attr):
		hurt_num *= 1.5 + (_atk_attr.crit_buff / 100.0)
		atk_type = Utils.HurtType.CRIT
	if fight_script.is_weak:
		hurt_num *= 0.6
	reflex_hurt(hurt_num,fight_script)
	updateHp(hurt_num)
	if hero_attr.hp <= 0:
		die()
	get_parent()._show_damage_label(hurt_num,atk_type)
	effect_sprite.visible = true
	effect_sprite.play("hit")

#直接数字伤害 number 伤害字 atk_type 攻击类型 _atk_attr 攻击者属性 is_COUTINUED是否连续
func do_number_hurt(number,atk_type,_atk_attr:HeroAttrBean,is_COUTINUED):
	var hurt_num = 0
	var _is_crit = false
	match atk_type as int:
		Utils.HurtType.ATK:
			hurt_num = number * (1 - ((hero_attr.def - _atk_attr.atk_pass)/100.0))#物理伤害
		Utils.HurtType.MTK:
			hurt_num = number * (1 - ((hero_attr.mdef - _atk_attr.mtk_pass)/100.0))#魔力伤害
		_:hurt_num = number
	if _atk_attr.skill_crit > 0 && randf() <  _atk_attr.skill_crit / 7000.0:
		hurt_num *= 1.5 + (_atk_attr.crit_buff / 100.0)
		_is_crit = true
	updateHp(hurt_num)
	if hero_attr.hp <= 0:
		die()
	if is_COUTINUED:
		get_parent()._show_damage_label(hurt_num,Utils.HurtType.COUTINUED)
	else:
		get_parent()._show_skill_label(hurt_num,_is_crit)

#刷血量
func updateHp(_num):
	if is_nohurt:
		return
	var hurt_num = _num
	if hero_attr.shield > 0:
		if hero_attr.shield - _num < 0:
			hurt_num -= hero_attr.shield
			hero_attr.shield = 0
			hero_attr.updateNum("shield",-hero_attr.shield)
		else:
			hero_attr.updateNum("shield",-_num)
	if hero_attr.shield <= 0:
		hero_attr.updateNum("hp",-hurt_num)

#反射触发
func reflex_hurt(_hurt_num,fight_script:Node):
	var num = _hurt_num
	if hero_attr.reflex > 0:
		num *= (hero_attr.reflex / 100.0)
		fight_script.do_number_hurt(num,0,hero_attr,false)

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
	if is_alive:
		is_in_atk = false
		is_alive = false
		hero_sprite.play("Die")
		get_parent().shape_2d.set_deferred("disabled",true)
		get_parent().resetSkill()
		get_tree().call_group("game_main","checkWin")

#直接数字回血
func hp_blood(blood):
	if is_sj:
		blood *= 0.4
	if hero_attr.hp + blood < hero_attr.max_hp:
		hero_attr.hp += blood
	else:
		hero_attr.hp = hero_attr.max_hp
	get_parent()._show_damage_label(blood,Utils.HurtType.BLOOD,true)

#物理攻击吸血
func atk_blood(num):
	if hero_attr.atk_blood > 0:
		var blood = num * (hero_attr.atk_blood / 100.0)
		if is_sj:
			blood *= 0.4
		if hero_attr.hp + blood < hero_attr.max_hp:
			hero_attr.hp += blood
		else:
			hero_attr.hp = hero_attr.max_hp
		get_parent()._show_damage_label(blood,Utils.HurtType.BLOOD)

#魔力攻击吸血
func mtk_blood(num):
	if hero_attr.mtk_blood > 0:
		var blood = num * (hero_attr.mtk_blood / 100.0)
		if is_sj:
			blood *= 0.4
		if hero_attr.hp + blood < hero_attr.max_hp:
			hero_attr.hp += blood
		else:
			hero_attr.hp = hero_attr.max_hp
		get_parent()._show_damage_label(blood,Utils.HurtType.BLOOD)

#战斗信号
func _on_AnimatedSprite_animation_finished():
	if is_in_atk:
		checkFightRole()

#战斗时每帧
func _on_AnimatedSprite_frame_changed():
	if is_in_atk && hero_sprite.animation == "Atk" && hero_sprite.frame == (hero_sprite.frames.get_frame_count("Atk") * 0.7) as int:
		if get_parent().is_shoot:
			get_parent().shotFireBall()
		else:
			doAtk()

func doAtk():
	if is_blinding && randf() <= 0.5:
		get_parent()._show_damage_label("丢失目标",Utils.HurtType.OTHER)
		return
	for role in do_atk_array:
		if role != null:
			role.fight_script.do_hurt(role_data,hero_attr,atk_mode,self)
	emit_signal("onAtkOver")

func reloadSpeed():
	hero_sprite.frames.set_animation_speed("Atk",speed_temp + (hero_attr.speed / 120.0))

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

func is_SJ():
	for item in state_array.values():
		if item is SkillStateBean && item.state_mold == Utils.BuffModeEnum.STATE && item.state_type == Utils.BuffStateEnum.SJ:
			return true
	return false

func is_NOHURT():
	for item in state_array.values():
		if item is SkillStateBean && item.state_mold == Utils.BuffModeEnum.STATE && item.state_type == Utils.BuffStateEnum.NOHURT:
			return true
	return false
