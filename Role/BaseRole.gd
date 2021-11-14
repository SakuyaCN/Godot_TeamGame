extends Node2D

onready var float_number = preload("res://Effect/FloatNumber.tscn")

var role_data:Dictionary#角色信息
var index = 0
var is_position = false
var is_moster = false
var run_position = Vector2.ZERO

var hero_attr:HeroAttrBean

onready var ui = $RoleUI

onready var am_player = $AnimationPlayer
onready var fight_script = $FightScript
onready var animatedSprite = $AnimatedSprite
onready var effect_anim = $Effects

func _ready():
	Console.add_command('addBuff', self, 'print_hello')\
		.set_description('Prints "Hello %name%!"')\
		.add_argument('name', TYPE_STRING)\
		.register()
 
func print_hello():
	var buff = load("res://Role/Skill/BaseState/Buff.gd").new()
	$SkillScript.add_child(buff)
	buff._create(StateEnum.BuffEnum.BUFF_ATK,30,5,hero_attr)

func set_role(_role_data):
	role_data = _role_data
	hero_attr = HeroAttrUtils.reloadHeroAttr(role_data)
	load_asset()
	ui.initRole()

func reloadRoleAttr(_rid,_attr:HeroAttrBean):
	if !fight_script.is_in_atk && role_data.rid == _rid:
		hero_attr.copy(_attr)
		print("穿戴刷新 %s" %hero_attr.hp)
		ui.load_attr()

func setIndex(_index):
	self.index = _index
	
func changeAnim(anim):
	animatedSprite.animation = anim

func load_asset():
	animatedSprite.position.y = -48
	match role_data.job:
		"黑袍法师":
			animatedSprite.frames = load("res://Texture/Pre-made characters/BlackHero.tres")
			animatedSprite.position.y = -120
			$RoleUI/name.rect_position.y = -15
			animatedSprite.scale = Vector2(4,4)
		"无畏勇者":
			animatedSprite.frames = load("res://Texture/Pre-made characters/Brave.tres")
			animatedSprite.position.y = -64
			$RoleUI/name.rect_position.y = -15
			animatedSprite.scale = Vector2(4,4)
		"不屈骑士":
			animatedSprite.frames = load("res://Texture/Pre-made characters/Knight.tres")
			animatedSprite.position.y = -86
			animatedSprite.scale = Vector2(5,5)
			$RoleUI/name.rect_position.y = -15
		"绝地武士":
			animatedSprite.frames = load("res://Texture/Pre-made characters/Warrior.tres")
			animatedSprite.position.y = -86
			animatedSprite.scale = Vector2(5,5)
			$RoleUI/name.rect_position.y = -15
		"致命拳手":
			animatedSprite.frames = load("res://Texture/Pre-made characters/Boxer.tres")
			animatedSprite.position.y = -70
			animatedSprite.scale = Vector2(3,3)
			$RoleUI/name.rect_position.y = -15
		"战地牧师":animatedSprite.frames = load("res://Texture/Pre-made characters/Minister.tres")
		"moster":
			is_moster = true
			effect_anim.flip_h = role_data["node"].flip_h
			animatedSprite.frames = load(role_data["node"].frames)
			animatedSprite.flip_h = role_data["node"].flip_h
			animatedSprite.position.y = role_data["node"].pos_y
			animatedSprite.scale = Vector2(role_data["node"].scale,role_data["node"].scale)
			$RoleUI/name.rect_position.y = role_data["node"].pos_y / 4
			$RoleUI/name.set("custom_colors/font_outline_modulate",Color.palevioletred)
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
	animatedSprite.speed_scale = 5.0
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
			global_position.x -= delta * 250
			if global_position.x <= run_position.position.x:
				animatedSprite.speed_scale = 1.0
				is_position = false
				set_process(false)
				animatedSprite.animation = "Idle"
				get_tree().call_group("game_main","moster_plus_size")

#玩家状态重置
func role_reset():
	hero_attr = HeroAttrUtils.reloadHeroAttr(role_data)
	ui.initRole()
	reloadHpBar()
	fight_script.load_script(is_moster)
	am_player.play_backwards("show_bar")
	animatedSprite.play("Run")

#展示血条
func show_bar(role_array):
	if am_player.is_playing():
		yield(am_player,"animation_finished")
	am_player.play("show_bar")
	fight_script.setFightRole(role_array)
	
#开始战斗
func start_fight():
	fight_script.do_atk()

func fight_win():
	fight_script.is_in_atk = false
	animatedSprite.play("Idle")

#刷新血条信息
func reloadHpBar():
	$RoleUI/hpbar/progress_hp.max_value = hero_attr.max_hp as int
	$RoleUI/hpbar/progress_hp.value = hero_attr.hp as int
	$RoleUI/hpbar/progress_hp/label_hp.text = str((hero_attr.hp as float/ hero_attr.max_hp as float * 100 )as int) + "%"

func _show_damage_label(damage,type):
	var color = Color.brown#基础物理伤害颜色
	var text = "-"
	var float_number_ins = float_number.instance()
	var vec = animatedSprite.position
	vec.y -= rand_range(-20,20)
	vec.x -= rand_range(-50,50)
	float_number_ins.position = vec
	float_number_ins.velocity = Vector2(rand_range(-40,40),-130)
	add_child(float_number_ins)
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
	float_number_ins.set_number(text + "%s" %damage,color)
	reloadHpBar()

func _on_Effects_animation_finished():
	effect_anim.visible = false

func _on_BaseRole_tree_exited():
	ConstantsValue.const_choose_role_arrt = null
