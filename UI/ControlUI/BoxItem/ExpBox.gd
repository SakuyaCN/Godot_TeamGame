extends Control

onready var hero_item = preload("res://UI/ItemUI/HeroItem.tscn")
onready var float_number = preload("res://Effect/FloatNumber.tscn")

var check_position
var is_lving = false


func _ready():
	add_to_group("exp_box")
	loadAllHero()
	reload()

func reload():
	$exp.text = "当前已累计经验(最多累1亿)：%s" %StorageData.get_player_state()["exp"] as int

#载入小队成员
func loadAllHero():
	for ins in $ScrollContainer/HSlider.get_children():
		ins.queue_free()
	var array = StorageData.get_all_team().values()
	$ScrollContainer/HSlider.get_children().clear()
	array.sort_custom(self, "customComparison")
	for item in array:
		var ins = hero_item.instance()
		ins.setData(item)
		ins.setLv()
		ins.connect("pressed",self,"all_hero_item_click",[item,ins])
		$ScrollContainer/HSlider.add_child(ins)

func all_hero_item_click(item,ins):
	if is_lving:
		return
	if StorageData.get_player_state()["exp"] > 0:
		is_lving = true
		addExp(item,StorageData.get_player_state()["exp"] as int)
		_show_skill_label(StorageData.get_player_state()["exp"] as int)
		ins.setLv()
		StorageData.get_player_state()["exp"] = 0
		reload()
		is_lving = false
	else:
		ConstantsValue.showMessage("已经没有经验值可以用了！",2)

#添加经验
func addExp(item,_exp):
	var hero_attr = HeroAttrUtils.reloadHeroAttr(null,item)
	if hero_attr.exp_buff > 0:
		_exp += (_exp * (hero_attr.exp_buff / 100.0)) as int
	is_LvUp(_exp,item)

#人物升级
func is_LvUp(_exp,role_data):
	var last_lv = role_data["lv"]
	if role_data.lv < 150:
		var minExp = (role_data["exp"] + _exp) - Utils.get_up_lv_exp(role_data["lv"])
		if minExp >= 0:
			role_data["lv"] += 1
			role_data["exp"] = 0
			is_LvUp(minExp,role_data)
		else:
			role_data["exp"] += _exp

#技能数值展示
func _show_skill_label(damage):
	var color = Color.aqua#基础物理伤害颜色
	var text = "Exp + "
	var float_number_ins = float_number.instance()
	float_number_ins.setSkill(true)
	var vec = get_local_mouse_position()
	vec.y -= rand_range(-20,20)
	vec.x -= rand_range(-50,50)
	float_number_ins.global_position = vec
	float_number_ins.velocity = Vector2(rand_range(-40,40),-130)
	add_child(float_number_ins)
	float_number_ins.set_number(text + "%s" %damage,color)
