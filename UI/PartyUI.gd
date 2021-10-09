extends Control

onready var skill_item = preload("res://UI/ItemUI/SkillItem.tscn")
onready var skill_tips = preload("res://UI/TipsUi/SkillTips.tscn")
onready var equ_item = preload("res://UI/ItemUI/RoleEquItem.tscn")
onready var label_ui = preload("res://UI/ControlUI/LabelItemUI.tscn")
onready var srcoll = $ScrollContainer
onready var click_timer = $ClickTimer
var role_data #当前选中英雄属性
var hero_attr :HeroAttrBean #当前选择英雄战斗属性
var skill_tips_ins = null#提示实例化
var select_index = 0
var tab_index = 0
var check_temp_ins = null #长按时的对象
onready var tab = [$attr,$skill_main,$equ_main]
onready var skill_item_position_array = []

#父节点拖拽图片
onready var temp_skill = get_parent()

func _ready():
	role_data = StorageData.get_all_team()[str(select_index)]
	hero_attr = HeroAttrUtils.reloadHeroAttr(role_data)
	visible = false
	var line = StyleBoxTexture.new()
	srcoll.get_h_scrollbar().set("custom_styles/scroll",line)
	loadHeroData()
	loadAllSkill()
	loadAllEqu()
	loadHeroEqu()

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
		tab_select(2)

func tab_select(index):
	for item in tab.size():
		if item == index:
			tab[item].visible = true
		else:
			tab[item].visible = false
	match index:
		0:
			$Skill_bg.visible = false
			$Equ_bg.visible = false
			closeEquInfo()
		1:
			$Skill_bg.visible = true
			$Equ_bg.visible = false
			closeEquInfo()
		2:
			$Equ_bg.visible = true
			$Skill_bg.visible = false

func closeEquInfo():
	$Equ_info.visible = false
	for item in$Equ_info/VBoxContainer.get_children():
		item.free()
	$Equ_info/VBoxContainer.get_children().clear()

func select(tab):
	pass

#载入部分
#=========================
func loadHeroData():
	$attr/label_hp.text = str(hero_attr.hp)
	$attr/label_atk.text = str(hero_attr.atk)
	$attr/label_mtk.text = str(hero_attr.mtk)
	$attr/label_def.text = str(hero_attr.def)
	$attr/label_speed.text = str(hero_attr.speed)
	$attr/label_crit.text = str(hero_attr.crit)
	$attr/label_mdef.text = str(hero_attr.mdef)
	$attr/label_lv.text = str(role_data.lv)

#载入人物所有技能
func loadAllSkill():
	for skill_data in StorageData.get_all_skill():
		var ins = skill_item.instance()
		ins.setData(LocalData.all_data["skill"][skill_data])
		ins.connect("pressed",self,"skill_item_click",[ins.local_data])
		ins.connect("button_down",self,"item_down",[ins])
		ins.connect("button_up",self,"item_up",[ins,"skill"])
		$Skill_bg/ScrollContainer/GridContainer.add_child(ins)

#载入人物所有装备
func loadAllEqu():
	for equ_data in StorageData.get_player_equipment(): 
		if !StorageData.get_player_equipment()[equ_data].is_on:
			var ins = equ_item.instance()
			ins.setData(StorageData.get_player_equipment()[equ_data])
			ins.connect("pressed",self,"equ_item_click",[ins.local_data])
			ins.connect("button_down",self,"item_down",[ins])
			ins.connect("button_up",self,"item_up",[ins,"equ"])
			$Equ_bg/ScrollContainer/GridContainer.add_child(ins)

#载入人物穿戴装备
func loadHeroEqu():
	for child in $equ_main/GridContainer.get_children():
		if role_data["equ"].has(child.type):
			if StorageData.get_player_equipment().has(role_data["equ"][child.type]):
				child.setData(StorageData.get_player_equipment()[role_data["equ"][child.type]])

#技能列表 点击绑定
#技能部分----------------
func skill_item_click(skill_data):
	if skill_tips_ins == null:
		skill_tips_ins = skill_tips.instance()
		add_child(skill_tips_ins)
	skill_tips_ins.showTips(skill_data["name"],skill_data["info"])

#技能列表 按下绑定
func item_down(ins):
	click_timer.start()
	set_process(true)
	check_temp_ins = ins
	
#技能列表 抬起绑定
func item_up(ins,type):
	set_process(false)
	click_timer.stop()
	var parant_grid = null
	match type:
		"skill": 
			parant_grid = $skill_main/GridContainer.get_children()
		"equ": 
			parant_grid = $equ_main/GridContainer.get_children()
			for child in parant_grid:
				if child.get_global_rect().has_point(get_global_mouse_position()):
					print(child.type)
					if check_temp_ins.local_data["type"] != child.type:
						get_parent().uiLayer.showMessage("此装备只能放入【"+ check_temp_ins.local_data["type"] +"】部位")
					else:
						setEqu2Role(child.type,check_temp_ins.local_data)
	check_temp_ins = null
	get_parent().tempSKillIcon.texture = null
	get_parent().tempSKillIcon.visible = false

#----------------------------
#装备列表绑定点击
func equ_item_click(equ_data):
	loadEquInfo(equ_data)
	#skill_tips_ins.showTips(skill_data["name"],skill_data["info"])

#===================================
func _on_ClickTimer_timeout():
	if check_temp_ins != null:
		get_parent().tempSKillIcon.texture = load(check_temp_ins.local_data.image)
		get_parent().tempSKillIcon.visible = true
		if skill_tips_ins != null:
			skill_tips_ins.close()

#穿戴装备
func setEqu2Role(type,equ_data):
	equ_data.is_on = true
	role_data["equ"][type] = equ_data["id"]
	StorageData._save_storage()
	loadHeroEqu()

#装备信息展示
func loadEquInfo(equ_data):
	$Equ_info.visible = true
	for item in$Equ_info/VBoxContainer.get_children():
		item.free()
	$Equ_info/VBoxContainer.get_children().clear()
	$Equ_info/equ_lv.text = "等级:%s" %equ_data["lv"]
	$Equ_info/equ_name.set('custom_colors/font_outline_modulate', EquUtils.get_quality_color(equ_data["quality"]))
	$Equ_info/equ_type.text = "类型:%s" %equ_data["type"]
	$Equ_info/equ_name.text = "["+ equ_data["quality"] +"]"+equ_data["name"]
	for attr_item in equ_data["base_attr"]:
		var label = label_ui.instance()
		label.text = EquUtils.get_attr_string(attr_item.keys()[0]) + " + %s" %attr_item.values()[0]
		$Equ_info/VBoxContainer.add_child(label)
	for attr_item in equ_data["ys_attr"]:
		var label = label_ui.instance()
		label.text = EquUtils.get_ys_string(attr_item.keys()[0]) + " + %s" %attr_item.values()[0]
		label.set('custom_colors/font_outline_modulate', EquUtils.get_ys_color(attr_item.keys()[0]))
		$Equ_info/VBoxContainer.add_child(label)

#装备按钮区域
#=========================
func _on_btn_down_pressed():
	pass # Replace with function body.
#=========================
