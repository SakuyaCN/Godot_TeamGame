extends Control

onready var skill_item = preload("res://UI/ItemUI/SkillItem.tscn")
onready var skill_tips = preload("res://UI/TipsUi/SkillTips.tscn")
onready var srcoll = $ScrollContainer
onready var role_data
var skill_tips_ins = null#提示实例化
var team_data = StorageData.get_all_team()
var select_index = 0

func _ready():
	role_data = team_data[str(select_index)]
	visible = false
	var line = StyleBoxTexture.new()
	srcoll.get_h_scrollbar().set("custom_styles/scroll",line)
	loadHeroData()
	loadAllSkill()
	
func partyChange(change):
	visible = change
	if !change && skill_tips_ins != null:
		skill_tips_ins.close()

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		partyChange(false)

func _on_status_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed() :
		pass

func _on_skill_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		pass

func _on_equ_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		pass

func select():
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

func loadAllSkill():
	for skill_data in StorageData.get_all_skill():
		var ins = skill_item.instance()
		ins.setData(LocalData.all_data["skill"][skill_data])
		ins.connect("pressed",self,"skill_item_click",[ins.local_data])
		$Skill_bg/ScrollContainer/GridContainer.add_child(ins)

#tem 点击绑定
func skill_item_click(skill_data):
	if skill_tips_ins == null:
		skill_tips_ins = skill_tips.instance()
	skill_tips_ins.showTips(skill_data["name"],skill_data["info"])
	add_child(skill_tips_ins)
