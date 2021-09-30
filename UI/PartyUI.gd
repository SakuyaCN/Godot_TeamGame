extends Control

onready var skill_item = preload("res://UI/ItemUI/SkillItem.tscn")
onready var skill_tips = preload("res://UI/TipsUi/SkillTips.tscn")
onready var srcoll = $ScrollContainer
onready var click_timer = $ClickTimer
onready var role_data
var skill_tips_ins = null#提示实例化
var team_data = StorageData.get_all_team()
var select_index = 0
var tab_index = 0
var check_temp_ins = null #长按时的技能对象
onready var tab = [$attr,$skill_main]
onready var skill_item_position_array = []

#父节点拖拽图片
onready var temp_skill = get_parent()

func _ready():
	role_data = team_data[str(select_index)]
	visible = false
	var line = StyleBoxTexture.new()
	srcoll.get_h_scrollbar().set("custom_styles/scroll",line)
	loadHeroData()
	loadAllSkill()

func _process(delta):
	if check_temp_ins != null && get_parent().tempSKillIcon.visible:
		get_parent().tempSKillIcon.set_global_position(get_global_mouse_position())

func partyChange(change):
	visible = change
	if !change && skill_tips_ins != null:
		skill_tips_ins.close()

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		partyChange(false)

func _on_status_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		tab_select(0)

func _on_skill_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		tab_select(1)

func _on_equ_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		pass

func tab_select(index):
	for item in tab.size():
		if item == index:
			tab[item].visible = true
		else:
			tab[item].visible = false
	match index:
		0:pass
		1:
			$Skill_bg.visible = true
		"equ":pass

func select(tab):
	pass

#载入部分
func loadHeroData():
	$attr/label_hp.text = str(role_data.attr.hp)
	$attr/label_atk.text = str(role_data.attr.atk)
	$attr/label_mtk.text = str(role_data.attr.mtk)
	$attr/label_def.text = str(role_data.attr.def)
	$attr/label_speed.text = str(role_data.attr.speed)
	$attr/label_crit.text = str(role_data.attr.crit)
	$attr/label_mdef.text = str(role_data.attr.mdef)
	$attr/label_lv.text = str(role_data.lv)

#载入人物所有技能
func loadAllSkill():
	for skill_data in StorageData.get_all_skill():
		var ins = skill_item.instance()
		ins.setData(LocalData.all_data["skill"][skill_data])
		ins.connect("pressed",self,"skill_item_click",[ins.local_data])
		ins.connect("button_down",self,"skill_item_down",[ins])
		ins.connect("button_up",self,"skill_item_up",[ins])
		$Skill_bg/ScrollContainer/GridContainer.add_child(ins)

#技能列表 点击绑定
func skill_item_click(skill_data):
	if skill_tips_ins == null:
		skill_tips_ins = skill_tips.instance()
		add_child(skill_tips_ins)
	skill_tips_ins.showTips(skill_data["name"],skill_data["info"])

#技能列表 按下绑定
func skill_item_down(ins):
	click_timer.start()
	check_temp_ins = ins
	
#技能列表 抬起绑定
func skill_item_up(ins):
	click_timer.stop()
	for child in $skill_main/GridContainer.get_children():
		if child.get_global_rect().has_point(get_global_mouse_position()):
			child.setData(check_temp_ins.local_data)
	check_temp_ins = null
	get_parent().tempSKillIcon.texture = null
	get_parent().tempSKillIcon.visible = false

func _on_ClickTimer_timeout():
	if check_temp_ins != null:
		get_parent().tempSKillIcon.texture = load(check_temp_ins.local_data.image)
		get_parent().tempSKillIcon.visible = true
		if skill_tips_ins != null:
			skill_tips_ins.close()
