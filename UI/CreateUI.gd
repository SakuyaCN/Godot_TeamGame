extends Control

onready var parent = get_parent()
onready var label_name = $name/Label8
onready var label_hp = $attr/label_hp
onready var label_atk = $attr/label_atk
onready var label_mtk = $attr/label_mtk
onready var label_def = $attr/label_def
onready var label_speed = $attr/label_speed
onready var label_crit = $attr/label_crit
onready var label_mdef = $attr/label_mdef
onready var label_lv = $attr/label_lv
onready var info = $content/RichTextLabel

var is_create = false

var base_role = [
	{
		"name":"黑袍法师",
		"lv":1,
		"hp":155,
		"atk":15,
		"def":2,
		"mtk":25,
		"speed":100,
		"crit":50,
		"mdef":0,
		"info":"黑袍为魔力型职业，可以打出高额魔力伤害，在前期怪物没用魔免的时期可以非常轻松的度过。\n职业特性：普攻伤害为魔力伤害，造成的魔力伤害无视5%的魔免，每10点魔力提高5点生命值与1点速度"
	},
	{
		"name":"无畏勇者",
		"lv":1,
		"hp":170,
		"atk":25,
		"def":2,
		"mtk":5,
		"speed":100,
		"crit":50,
		"mdef":2,
		"info":"勇者为平衡型职业，拥有出色的伤害的同时还能有一定的防御，不管是在前中后期都能发挥出不错的实力。\n职业特性：每次升级额外获得20点生命值与5点攻击力，自带5%的伤害吸血"
	},
	{
		"name":"不屈骑士",
		"lv":1,
		"hp":200,
		"atk":15,
		"def":8,
		"mtk":5,
		"speed":100,
		"crit":50,
		"mdef":6,
		"info":"骑士为防御型职业，拥有高超的防御技巧，越是往后期越是能体现出高防御的优点。\n职业特性：血量收益提高10%，自带6%的额外物免与魔免，每次升级额外获得35点生命值"
	},
	{
		"name":"绝地武士",
		"lv":1,
		"hp":155,
		"atk":25,
		"def":0,
		"mtk":5,
		"speed":150,
		"crit":100,
		"mdef":0,
		"info":"武士为强攻型职业，注重速度与暴击，但是防御较为薄弱。\n职业特性：暴击伤害提高50%，速度收益提高6%，无自带防御力，每次升级额外额外获得25点速度与暴击"
	},
	{
		"name":"致命拳手",
		"lv":1,
		"hp":175,
		"atk":18,
		"def":5,
		"mtk":5,
		"speed":100,
		"crit":50,
		"mdef":3,
		"info":"拳手为攻防一体型职业，速度力量防御三维全面发展。\n职业特性：攻击收益提高3%，自带3%的额外物免与魔免，每次升级额外提高25点生命值、10点攻击力、10点速度"
	},
	{
		"name":"战地女神",
		"lv":1,
		"hp":165,
		"atk":12,
		"def":7,
		"mtk":15,
		"speed":100,
		"crit":50,
		"mdef":5,
		"info":"战地女神支援型职业，后期拥有各种团队BUFF加成，全体治疗等辅助技能。\n职业特性：魔力收益提高5%，自带5%的额外物免与魔免，每次升级额外提高15点生命值、10点攻击力、5点魔力"
	}
]
var check_index = 0
var count_max = 5

func _ready():
	visible = false
	load_info()

func showCreate(_is_create = false):
	is_create = _is_create
	if _is_create:
		$TextEdit.visible = false
	visible = true

func load_info():
	label_name.text = base_role[check_index].name
	label_hp.text = str(base_role[check_index].hp)
	label_atk.text = str(base_role[check_index].atk)
	label_def.text = str(base_role[check_index].def)
	label_speed.text = str(base_role[check_index].speed)
	label_mtk.text = str(base_role[check_index].mtk)
	label_crit.text = str(base_role[check_index].crit)
	label_mdef.text = str(base_role[check_index].mdef)
	label_lv.text = str(base_role[check_index].lv)
	info.bbcode_text = base_role[check_index].info
	match check_index as int:
		0:
			$role/AnimatedSprite.frames = load("res://Texture/Pre-made characters/BlackHero.tres")
			$role/AnimatedSprite.position = Vector2(5,-59)
			$role/AnimatedSprite.scale = Vector2(3,3)
		1:
			$role/AnimatedSprite.frames = load("res://Texture/Pre-made characters/Brave.tres")
			$role/AnimatedSprite.position = Vector2(5,-58)
			$role/AnimatedSprite.scale = Vector2(3,3)
		2:
			$role/AnimatedSprite.frames = load("res://Texture/Pre-made characters/Knight.tres")
			$role/AnimatedSprite.position = Vector2(5,-95)
			$role/AnimatedSprite.scale = Vector2(5,5)
		3:
			$role/AnimatedSprite.frames = load("res://Texture/Pre-made characters/Warrior.tres")
			$role/AnimatedSprite.position = Vector2(5,-95)
			$role/AnimatedSprite.scale = Vector2(5,5)
		4:
			$role/AnimatedSprite.frames = load("res://Texture/Pre-made characters/Boxer.tres")
			$role/AnimatedSprite.position = Vector2(3,-83)
			$role/AnimatedSprite.scale = Vector2(3,3)
		5:
			$role/AnimatedSprite.frames = load("res://Texture/Pre-made characters/Goddess.tres")
			$role/AnimatedSprite.position = Vector2(0,-100)
			$role/AnimatedSprite.scale = Vector2(3,3)

func _on_left_pressed():
	if check_index == 0:
		check_index = count_max
	else:
		check_index -=1
	load_info()

func _on_right_pressed():
	if check_index == count_max:
		check_index = 0
	else:
		check_index +=1
	load_info()

func _on_Button_pressed():
	if !is_create:
		if $TextEdit.text == "":
			ConstantsValue.showMessage("请输入小队名称",2)
			return
		var id = str(OS.get_system_time_msecs())
		createNewRole(id)
		StorageData.storage_data["player_state"] = {
			"job":base_role[check_index].name,
			"exp":0,
			"lv":1,
			"nickname":$TextEdit.text,
			"gold":1000,
			"save_id":id+ str(randi()%100000),
			"map_index":0,
			"map_index_max":0,
			"seal_return_lv":0,
			"map":{
				"0":{"max_map": 0,"now_map": 0},
				"1":{"max_map": 0,"now_map": 0},
				"2":{"max_map": 0,"now_map": 0},
				"3":{"max_map": 0,"now_map": 0},
			},
			"team_position":[id,null,null]
		}
		StorageData.reloadData()
		StorageData._save_storage()
		hide()
		parent.uiLayer.get_parent().start_game()
		get_tree().call_group("PartyUI","loadFirst")
		parent.uiLayer.showMessage("创建成功！")
	else:
		if StorageData.UseGoodsNum([["小队招募令",1]]):
			var id = str(OS.get_system_time_msecs())
			createNewRole(id)
			addNewRole()

func addNewRole():
	StorageData.reloadData()
	StorageData._save_storage()
	parent.uiLayer.showMessage("招募成功！")
	get_tree().call_group("PartyUI","loadFirst")
	hide()

func createNewRole(_id):
	var main_role = {
		"rid":_id,#编号
		"nickname":base_role[check_index].name,
		"job":base_role[check_index].name,#职业
		"exp":0,#经验
		"lv":1,#等级
		"atk_count":1,#攻击数量
		"attr":{#属性
			"hp":base_role[check_index].hp,
			"atk":base_role[check_index].atk,
			"mtk":base_role[check_index].mtk,
			"def":base_role[check_index].def,
			"speed":base_role[check_index].speed,
			"crit":base_role[check_index].crit,
			"mdef":base_role[check_index].mdef
		},
		"skill":[],#技能
		"equ":{},#装备
	}
	StorageData.storage_data["team"][main_role.rid] = main_role
	get_tree().call_group("PartyUI","loadAllHero")
	ConstantsValue.ui_layer.getNewItem("新冒险者加入！","res://Texture/hud/Assets-2(Scale-x2)-No.png")
