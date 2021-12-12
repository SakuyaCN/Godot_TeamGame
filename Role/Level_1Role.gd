extends KinematicBody2D

onready var float_number = preload("res://Effect/FloatNumber.tscn")
onready var fire_ball = preload("res://Effect/Projectile.tscn")

onready var shape_2d = $CollisionShape2D
var role_data:Dictionary#角色信息
var index = 0
var is_position = false
var is_moster = false
var run_position = Vector2.ZERO
var ui = null
var enemy_array # 敌人数组
var myself_array #自己人数组

var hero_attr:HeroAttrBean = null
var hero_skill = {}
var is_shoot = false
var is_start_fight = false
onready var fight_script = $FightScript
onready var skill_script = $SkillScript
onready var skill_node = $SkillNode
onready var animatedSprite = $AnimatedSprite
onready var effect_anim = $Effects

func _ready():
	name = str(OS.get_system_time_msecs() + randi()%10000)

#添加经验
func addExp(_exp):
	if StorageData.get_player_state()["exp"] < 10000000:
		StorageData.get_player_state()["exp"] += (_exp * 0.4)
		get_tree().call_group("exp_box","reload")
	if hero_attr.exp_buff > 0:
		_exp += (_exp * (hero_attr.exp_buff / 100.0)) as int
	is_LvUp(_exp)
	_show_damage_label("EXP+%d"%_exp,Utils.HurtType.EXP,true)

#人物升级
func is_LvUp(_exp):
	var last_lv = role_data["lv"]
	if role_data.lv < 100:
		var minExp = (role_data["exp"] + _exp) - Utils.get_up_lv_exp(role_data["lv"])
		if minExp >= 0:
			role_data["lv"] += 1
			role_data["exp"] = 0
			is_LvUp(minExp)
			_show_damage_label("升级！",Utils.HurtType.EXP,true)
		else:
			role_data["exp"] += _exp
		if last_lv != role_data["lv"] && !fight_script.is_in_atk:
			hero_attr = HeroAttrUtils.reloadHeroAttr(self,role_data)

#初始化角色
func set_role(_role_data):
	role_data = _role_data
	hero_attr = HeroAttrUtils.reloadHeroAttr(self,role_data)
	load_asset()

func setOnlineData(_role_data,_hero_attr):
	role_data = _role_data
	hero_attr = HeroAttrBean.new()
	hero_attr.toBean(_hero_attr)
	load_asset()

func setIndex(_index):
	self.index = _index

func changeAnim(anim):
	animatedSprite.animation = anim

#资源载入
func load_asset():
	animatedSprite.position.y = -48
	match role_data.job:
		"黑袍法师":
			fight_script.atk_mode = Utils.HurtType.MTK
			animatedSprite.frames = load("res://Texture/Pre-made characters/BlackHero.tres").duplicate()
			animatedSprite.position.y = -60
			animatedSprite.position.x = -5
			animatedSprite.scale = Vector2(3.5,3.5)
		"无畏勇者":
			animatedSprite.frames = load("res://Texture/Pre-made characters/Brave.tres").duplicate()
			animatedSprite.position.y = -64
			animatedSprite.scale = Vector2(4,4)
		"不屈骑士":
			animatedSprite.frames = load("res://Texture/Pre-made characters/Knight.tres").duplicate()
			animatedSprite.position.y = -86
			animatedSprite.scale = Vector2(5,5)
		"绝地武士":
			animatedSprite.frames = load("res://Texture/Pre-made characters/Warrior.tres").duplicate()
			animatedSprite.position.y = -86
			animatedSprite.scale = Vector2(5,5)
		"致命拳手":
			animatedSprite.frames = load("res://Texture/Pre-made characters/Boxer.tres").duplicate()
			animatedSprite.position.y = -70
			animatedSprite.scale = Vector2(3,3)
		"战地女神":
			animatedSprite.frames = load("res://Texture/Pre-made characters/Goddess.tres").duplicate()
			animatedSprite.position.y = -95
			animatedSprite.scale = Vector2(3,3)
		"moster":
			is_moster = true
			effect_anim.flip_h = role_data["node"].flip_h
			animatedSprite.frames = load(role_data["node"].frames).duplicate()
			animatedSprite.flip_h = role_data["node"].flip_h
			animatedSprite.position.y = role_data["node"].pos_y
			animatedSprite.scale = Vector2(role_data["node"].scale,role_data["node"].scale)
			if role_data["node"].has("shoot"):
				is_shoot = true
	animatedSprite.animation = "Idle"
	effect_anim.position.y = animatedSprite.position.y / 2
	effect_anim.visible = false
	if is_moster:
		add_to_group("moster_role")
	else:
		add_to_group("player_role")
	fight_script.load_script(is_moster)

func run2position(_position):
	animatedSprite.animation = "Run"
	if not is_moster:
		global_position = Vector2(-100,_position.position.y)
	else:
		global_position = Vector2(1337,_position.position.y)
	animatedSprite.speed_scale = 3.0
	run_position = _position
	is_position = true

func _process(delta):
	if is_position:
		if not is_moster:
			global_position.x += delta * 250
			if global_position.x >= run_position.position.x:
				animatedSprite.speed_scale = 1.0
				is_position = false
				set_process(false)
				get_tree().call_group("game_main","plus_size")
		else:
			global_position.x -= delta * 350
			if global_position.x <= run_position.position.x:
				animatedSprite.speed_scale = 1.0
				is_position = false
				set_process(false)
				animatedSprite.animation = "Idle"
				get_tree().call_group("game_main","moster_plus_size")

#初始化装载技能
func AddRoleSkill(_skill_data):
	var skill_bean = SkillEntity.new()
	#skill_bean.loadSkill(_skill_data)
	skill_node.add_child(skill_bean)
	skill_bean.loadRoleArray(enemy_array,myself_array,self,skill_script)
	skill_bean.auto_start(_skill_data)

#玩家状态重置
func role_reset():
	is_start_fight = false
	#shape_2d.set_deferred("disabled",false)
	resetSkill()
	hero_attr = HeroAttrUtils.reloadHeroAttr(self,role_data)
	fight_script.do_stop()
	hero_skill.clear()
	animatedSprite.play("Idle")

#重置技能状态列表
func resetSkill():
	if !fight_script.is_alive:
		get_parent().get_parent().game_over()
	for item in $SkillScript.get_children():
		item._destroy()
		item.queue_free()
	$SkillScript.get_children().clear()
	fight_script.state_array.clear()
	for item in skill_node.get_children():
		item.queue_free()
	skill_node.get_children().clear()

func shotFireBall():
	var is_left = Vector2.LEFT
	if !is_moster:
		is_left = Vector2.RIGHT
	var projectile_vector: Vector2 = (is_left * 500).rotated($ShotLine.global_rotation)
	var ins = fire_ball.instance()
	$ShotLine.add_child(ins)
	var is_line 
	if is_moster && role_data["node"].has("line"):
		is_line = role_data["node"]["line"]
	ins.shoot(self,$ShotLine.global_position,projectile_vector,1500,100,100,is_line)

#添加状态
func addState(state:SkillStateBean,state_node:BaseState):
	if fight_script.state_array.has(state.state_id):
		var node = skill_script.get_node(state.state_id)
		if !state.state_over:
			node.reset()
		else:
			node.addTime()
	else:
		skill_script.add_child(state_node)
		fight_script.state_array[state.state_id] = state

#移除状态
func removeState(id):
	fight_script.state_array.erase(id)

func setRoleScript(_enemy_array,_myself_array):
	enemy_array = _enemy_array
	myself_array = _myself_array
	fight_script.setFightRole(_enemy_array)
	max_shield = hero_attr.shield
	if max_shield == 0:
		$mpbar/progress_sd.value = 0

#开始战斗
func start_fight():
	is_start_fight = true
	fight_script.do_atk()

#战斗结束
func fight_over():
	fight_script.is_in_atk = false
	animatedSprite.play("Idle")
	#role_reset()

var max_shield = 0

#刷新血条信息
func reloadHpBar():
	$hpbar/progress_hp.max_value = hero_attr.max_hp as int
	$hpbar/progress_hp.value = hero_attr.hp as int
	$hpbar/progress_hp/label_hp.text = str((hero_attr.hp as float/ hero_attr.max_hp as float * 100 )as int) + "%"
	
	$mpbar/progress_sd.max_value = max_shield
	$mpbar/progress_sd.value = hero_attr.shield as int
	$mpbar/progress_sd/label_sd.text = "%s点"%hero_attr.shield
	

#战斗数字显示
func _show_damage_label(damage,type,is_max = false):
	reloadHpBar()
	if !ConstantsValue.is_fight_num:
		return
	var color = Color.brown#基础物理伤害颜色
	var text = "-"
	var float_number_ins = float_number.instance()
	var vec = animatedSprite.position
	vec.y -= rand_range(-10,10)
	vec.x -= rand_range(-30,30)
	float_number_ins.setSkill(is_max)
	float_number_ins.position = vec
	float_number_ins.velocity = Vector2(rand_range(-40,40),-130)
	match type:
		Utils.HurtType.MTK:
			color = Color.cornflower
			text = "-"
		Utils.HurtType.TRUE:
			color = Color.lightgray
			text = "-"
		Utils.HurtType.BLOOD:
			color = Color.yellowgreen
			text = "+"
		Utils.HurtType.MISS:
			color = Color.slategray
			text = ""
		Utils.HurtType.HOLD:
			color = Color.silver
			text = "格挡 -"
		Utils.HurtType.CRIT:
			color = Color.tomato
		Utils.HurtType.OTHER:
			color = Color.peru
			text = ""
			float_number_ins.mass = 500
		Utils.HurtType.COUTINUED:
			color = Color.webpurple
			text = "-"
			float_number_ins.mass = 500
		Utils.HurtType.EXP:
			color = Color.cornflower
			text = ""
	add_child(float_number_ins)
	float_number_ins.set_number(text + "%s" %damage,color)

#技能数值展示
func _show_skill_label(damage,is_crit = false):
	reloadHpBar()
	if !ConstantsValue.is_fight_num:
		return
	var color = Color.steelblue#基础物理伤害颜色
	if is_crit:
		color = Color.rebeccapurple
	var text = "-"
	var float_number_ins = float_number.instance()
	float_number_ins.setSkill(true)
	var vec = animatedSprite.position
	vec.y -= rand_range(-20,20)
	vec.x -= rand_range(-50,50)
	float_number_ins.position = vec
	float_number_ins.velocity = Vector2(rand_range(-40,40),-130)
	add_child(float_number_ins)
	float_number_ins.set_number(text + "%s" %damage,color)

func _on_Effects_animation_finished():
	effect_anim.visible = false

func _on_BaseRole_tree_exited():
	ConstantsValue.const_choose_role_arrt = null
