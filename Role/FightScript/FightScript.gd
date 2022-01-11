extends Node

var fight_role_array = [] setget setFightRole#战斗对象
var do_atk_array = []#攻击对象数据
onready var hero_sprite:AnimatedSprite
onready var effect_sprite:AnimatedSprite
onready var role_data#当前人物数据
onready var hero_attr:HeroAttrBean#当前人物属性
onready var is_in_atk = false #是否处于攻击动作
var skill_bs = 0.8#技能伤害倍数
var speed_temp = 0
var is_alive = true#是否存活
var is_moster = false#是否为怪物
var is_blinding = false #是否为致盲状态
var is_weak = false #是否为虚弱状态
var is_sj = false #是否为重伤
var is_nohurt =false
var atk_count #攻击数量
var state_array = {} #状态列表
var atk_frame = []

var is_in_skill = false

var atk_mode = Utils.HurtType.ATK #普攻攻击类型

signal onAtkOver()#普攻结束信号
signal onDie(node)
signal onHurt(_atk_data,number)

func _ready():
	pass

func _on_Timer_timeout():
	if is_alive && is_in_atk:
		if is_VERTIGO():
			if hero_sprite.animation != "Idle":
				hero_sprite.animation = "Idle"
		else:
			if hero_sprite.animation != "Atk" && !is_in_skill:
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
			hurt_num = _atk_attr.atk * getHurtPass(hero_attr.def,_atk_attr.atk_pass)
			hurt_num *= 1 + (hero_attr.atk_hurt_buff / 100.0)
			fight_script.atk_blood(hurt_num)
		Utils.HurtType.MTK:
			hurt_num = _atk_attr.mtk * getHurtPass(hero_attr.mdef,_atk_attr.mtk_pass) 
			hurt_num *= 1 + (hero_attr.mtk_hurt_buff / 100.0)
			fight_script.mtk_blood(hurt_num)
	#攻击附带魔力
	hurt_num += atkHasMtk(_atk_attr)
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
	updateHp(hurt_num,false,atk_type)
	emit_signal("onHurt",_atk_data,hurt_num)
	if hero_attr.hp <= 0:
		die()
	effect_sprite.visible = true
	effect_sprite.play("hit")

#直接数字伤害 _atk_data 攻击者信息 number 伤害字 atk_type 攻击类型 _atk_attr 攻击者属性 is_COUTINUED是否连续
func do_number_hurt(_atk_data,number,atk_type,_atk_attr:HeroAttrBean,is_COUTINUED):
	var hurt_num = 0
	var _is_crit = false
	match atk_type as int:
		Utils.HurtType.ATK:
			hurt_num = number * getHurtPass(hero_attr.def,_atk_attr.atk_pass) 
			hurt_num *= 1 + (hero_attr.atk_hurt_buff / 100.0)
		Utils.HurtType.MTK:
			hurt_num = number * getHurtPass(hero_attr.mdef,_atk_attr.mtk_pass)
			hurt_num *= 1 + (hero_attr.mtk_hurt_buff / 100.0)
		Utils.HurtType.TRUE:hurt_num = number
	if _atk_attr.skill_buff > 0:
		hurt_num *=  1 + (_atk_attr.skill_buff / 100.0)
	if  atk_type as int != Utils.HurtType.TRUE && _atk_attr.skill_crit > 0 && randf() <  _atk_attr.skill_crit / 7000.0:
		hurt_num *= 1.5 + (_atk_attr.crit_buff / 100.0)
		_is_crit = true
	if is_COUTINUED:
		updateHp(hurt_num,false,Utils.HurtType.COUTINUED)
	else:
		updateHp(hurt_num,true,_is_crit)
	if hero_attr.hp <= 0:
		die()
	emit_signal("onHurt",_atk_data,hurt_num)

func getHurtPass(_my_def,_pass):
	if 1 - ((_my_def - _pass)/100.0) <=0:
		return 0.0001
	return 1 - ((_my_def - _pass)/100.0)

#攻击附带魔力值
func atkHasMtk(_atk_attr:HeroAttrBean):
	var num = 0
	if _atk_attr.atk_mtk > 0:
		num += (_atk_attr.atk_mtk / 100.0) * _atk_attr.mtk
		num = num * (1 - ((hero_attr.mdef - _atk_attr.mtk_pass)/100.0))
		num *= 1 + (hero_attr.mtk_hurt_buff / 100.0)
	return num

#刷血量
func updateHp(_num,is_skill,type):
	if is_nohurt:
		get_parent()._show_skill_label("无敌")
		return
	var hurt_num = _num * (1 - hero_attr.hurt_pass / 100.0)
	if hero_attr.shield > 0:
		if hero_attr.shield_buff > 0:
			#get_parent()._show_damage_label("护盾免伤-%s"%sh_buff,Utils.HurtType.OTHER)
			var hf = (1 - hero_attr.shield_buff/ 100.0)
			if hf <= 0:
				hf = 0.01
			hurt_num = hurt_num * hf
		if hero_attr.shield - hurt_num < 0:
			hurt_num -= hero_attr.shield
			hero_attr.shield = 0
			hero_attr.updateNum("shield",-hero_attr.shield)
		else:
			if hurt_num < 0:
				hurt_num = 0
			hero_attr.updateNum("shield",-hurt_num)
	if hero_attr.shield <= 0:
		hero_attr.updateNum("hp",-hurt_num)
	if !is_skill:
		get_parent()._show_damage_label(hurt_num,type)
	else:
		get_parent()._show_skill_label(hurt_num,type)

#反射触发
func reflex_hurt(_hurt_num,fight_script:Node):
	var num = _hurt_num
	if hero_attr.reflex > 0:
		num *= (hero_attr.reflex / 100.0)
		fight_script.do_number_hurt(role_data,num,2,hero_attr,false)

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
	var crit = _atk_attr.crit
	if hero_attr.uncrit > 0:
		crit -= hero_attr.uncrit
	if crit > 0 && randf() <  crit / 7000.0:
		return true
	else:
		return false

#人物死亡
func die():
	if is_alive:
		is_in_atk = false
		is_alive = false
		hero_sprite.play("Die")
		emit_signal("onDie",get_parent())
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
	if is_in_skill:
		skill_bs *= skill_bs
		for role in do_atk_array:
			if role != null && is_instance_valid(role) && role.fight_script.is_alive:
				role.fight_script.do_number_hurt(role_data,(hero_attr.mtk + hero_attr.atk) * skill_bs,atk_mode,hero_attr,false)
		is_in_skill = false
	if is_in_atk:
		checkFightRole()

#战斗时每帧
func _on_AnimatedSprite_frame_changed():
	if is_in_atk && hero_sprite.animation == "Atk" && !is_in_skill:
		if atk_frame.size() == 0 && hero_sprite.frame == (hero_sprite.frames.get_frame_count("Atk") * 0.7) as int:
			if get_parent().is_shoot:
				get_parent().shotFireBall()
			else:
				doAtk()
		elif is_moster && atk_frame.has(hero_sprite.frame):
			if get_parent().is_shoot:
				get_parent().shotFireBall()
			else:
				doAtk()

func doAtk():
	if is_blinding && randf() <= 0.5:
		get_parent()._show_damage_label("丢失目标",Utils.HurtType.OTHER)
		return
	for role in do_atk_array:
		if role != null && is_instance_valid(role) && role.fight_script.is_alive:
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
