extends Control

onready var discard_ui = preload("res://UI/ControlUI/DiscardUI.tscn")
onready var skill_item = preload("res://UI/ItemUI/SkillItem.tscn")
onready var skill_tips = preload("res://UI/TipsUi/SkillTips.tscn")
onready var equ_item = preload("res://UI/ItemUI/RoleEquItem.tscn")
onready var label_ui = preload("res://UI/ControlUI/LabelItemUI.tscn")
onready var hero_item = preload("res://UI/ItemUI/HeroItem.tscn")
onready var equ_info = preload("res://UI/ItemUI/Equ_info.tscn")
onready var over_item = preload("res://UI/ControlUI/EquOver.tscn")#融合界面
onready var srcoll = $ScrollContainer
onready var click_timer = $ClickTimer
onready var position_img = $TextureRect2
onready var position_label = $TextureRect2/position
var over_ins = null#融合界面是否展示
var role_position = -1 #选中英雄的位置
var role_data #当前选中英雄属性
var hero_attr :HeroAttrBean = null#当前选择英雄战斗属性
var check_equ_data #选择时的装备数据
var skill_tips_ins = null#提示实例化
var select_index = "" #当前选中的英雄下表
var tab_index = 0
var check_temp_ins = null #长按时的对象
onready var tab = [$attr,$skill_main,$equ_main]
onready var skill_item_position_array = []

var is_first_load = false

#父节点拖拽图片
onready var temp_skill = get_parent()

func _ready():
	loadEquEmp()
	add_to_group("PartyUI")
	$Equ_info.visible = false
	visible = false
	set_process(false)
	var line = StyleBoxTexture.new()
	srcoll.get_h_scrollbar().set("custom_styles/scroll",line)
	$Equ_bg/ScrollContainer.get_v_scrollbar().set("custom_styles/scroll",line)
	is_first_load = loadFirst()

func loadFirst():
	if StorageData.get_all_team().keys().size() > 0:
		loadAllHero()
		loadAllSkill()
		loadAllEqu()
		loadHeroEqu()
		checkHeroData()
	return true

func loadEquEmp():
	for index in range(100):
		var ins = equ_item.instance()
		$Equ_bg/ScrollContainer/GridContainer.add_child(ins)
		ins.setData(null)
		ins.connect("pressed",self,"equ_item_click",[ins])
	for item in $skill_main/GridContainer.get_children():
		item.connect("pressed",self,"skill_role_click",[item])

func showPosition():
	if role_data != null:
		role_position = StorageData.get_player_state().team_position.find(role_data.rid)
		match role_position:
			0:
				position_label.text = "前排"
			1:
				position_label.text = "中卫"
			2:
				position_label.text = "后排"
			_:
				position_label.text = "点这出战"

#点击英雄刷新
func checkHeroData():
	select_index = role_data.rid
	showPosition()
	loadHeroData()
	loadHeroSkill()
	reLoadHeroEqu()

func _process(_delta):
	if check_temp_ins != null && get_parent().tempSKillIcon.visible:
		get_parent().tempSKillIcon.set_global_position(get_global_mouse_position())

func partyChange(change):
	visible = change
	if !change && skill_tips_ins != null:
		skill_tips_ins.close()
		set_process(false)
	if visible:
		checkHeroData()
	if visible && !ConfigScript.getBoolSetting("store","first_open_party"):#首次打开炼金台
		var new_dialog = Dialogic.start('first_open_party')
		add_child(new_dialog)
		ConfigScript.setBoolSetting("store","first_open_party",true)

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

#载入部分
#=========================
#载入小队成员
func loadAllHero():
	for ins in $ScrollContainer/HSlider.get_children():
		ins.queue_free()
	var array = StorageData.get_all_team().values()
	$ScrollContainer/HSlider.get_children().clear()
	array.sort_custom(self, "customComparison")
	if select_index == "":
		role_data = array[0]
		select_index = role_data.rid
	for item in array:
		var ins = hero_item.instance()
		ins.setData(item)
		ins.connect("pressed",self,"all_hero_item_click",[item])
		$ScrollContainer/HSlider.add_child(ins)
	get_tree().call_group("all_hero_list","reload",select_index)

#小成员排序
func customComparison(a,b):
	if StorageData.get_player_state()["team_position"].find(a.rid) > StorageData.get_player_state()["team_position"].find(b.rid):
		return a

#小队成员点击
func all_hero_item_click(item_key):
	$PostionBox.visible = false
	$Equ_info.visible = false
	role_data = item_key
	#tab_select(0)
	get_tree().call_group("all_hero_list","reload",item_key.rid)
	yield(get_tree(),"idle_frame")
	checkHeroData()
	
#载入当前英雄属性
func loadHeroData():
	hero_attr = HeroAttrUtils.reloadHeroAttr(null,role_data)
	get_tree().call_group("player_role","reloadRoleAttr",role_data.rid,hero_attr)
	$TextureRect/name.text = role_data.nickname
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
	free_item($Skill_bg/ScrollContainer/GridContainer.get_children())
	for skill in StorageData.get_all_skill():
		if skill.role == null:
			var ins = skill_item.instance()
			ins.skill_role = skill
			ins.setData(Utils.findSkillFromAll(skill.form))
			ins.connect("pressed",self,"skill_item_click",[ins])
			ins.connect("button_down",self,"item_down",[ins])
			ins.connect("button_up",self,"item_up",["skill"])
			$Skill_bg/ScrollContainer/GridContainer.add_child(ins)

#载入人物所有装备
func loadAllEqu():
	var index = 0
	var equ_array = StorageData.get_player_equipment().values()
	for item in $Equ_bg/ScrollContainer/GridContainer.get_children():
		if equ_array.size() > index && equ_array[index] != null && !equ_array[index].is_on:
			item.visible = true
			item.setData(equ_array[index])
			item.setName("Lv.%s" %equ_array[index].lv)
		else:
			item.setData(null)
			item.visible = false
		index += 1
	equ_array.clear()

#载入人物穿戴装备
func loadHeroEqu():
	if role_data != null:
		for child in $equ_main/GridContainer.get_children():
			child.connect("pressed",self,"hero_equ_click",[child])

#刷新人物穿戴装备
func reLoadHeroEqu():
	for child in $equ_main/GridContainer.get_children():
		if role_data["equ"].has(child.type):
			if StorageData.get_player_equipment().has(str(role_data["equ"][child.type])):
				child.setData(StorageData.get_player_equipment()[str(role_data["equ"][child.type])])
		else:
			child.setData(null)

#载入人物穿戴技能
func loadHeroSkill():
	if role_data != null:
		for index in range($skill_main/GridContainer.get_child_count()):
			if role_data["skill"].size() > index:
				$skill_main/GridContainer.get_child(index).setSkill(Utils.findSkillFromAll(role_data["skill"][index].form),role_data["skill"][index])
			else:
				$skill_main/GridContainer.get_child(index).setSkill(null,null)

#技能列表 点击绑定
#技能部分----------------
func skill_role_click(_skill_ins):
	if _skill_ins.skill_role == null:
		return
	if skill_tips_ins == null:
		skill_tips_ins = skill_tips.instance()
		add_child(skill_tips_ins)
	skill_tips_ins.showTips(_skill_ins.skill_role,_skill_ins.local_data["skill_name"],_skill_ins.local_data["skill_info"],_skill_ins.local_data["skill_lv"],role_data)

func skill_item_click(_skill_ins):
	if skill_tips_ins == null:
		skill_tips_ins = skill_tips.instance()
		add_child(skill_tips_ins)
	skill_tips_ins.showTips(_skill_ins.skill_role,_skill_ins.local_data["skill_name"],_skill_ins.local_data["skill_info"],_skill_ins.local_data["skill_lv"])

#技能列表 按下绑定
func item_down(ins):
	click_timer.start()
	set_process(true)
	check_temp_ins = ins
	
#技能列表 抬起绑定
func item_up(_type):
	set_process(false)
	click_timer.stop()
	var parant_grid
	match _type:
		"skill":
			parant_grid = $skill_main/GridContainer.get_children()
			for child in parant_grid:
				if child.get_global_rect().has_point(get_global_mouse_position()):
					if check_temp_ins.local_data.has("skill_job") && check_temp_ins.local_data.skill_job != role_data.job:
						ConstantsValue.showMessage("无法佩戴其他职业技能",2)
						item_up_clear()
						return
					if role_data["skill"].size() >= 5:
						ConstantsValue.showMessage("请先卸下一个技能后佩戴",2)
						item_up_clear()
						return
					if Utils.findSkillFromPlayer(role_data,check_temp_ins.skill_role.form):
						ConstantsValue.showMessage("相同技能最多佩戴1个",2)
						item_up_clear()
						return
					if check_temp_ins.local_data.skill_lv > role_data["lv"]:
						item_up_clear()
						ConstantsValue.showMessage("冒险者等级不足！",2)
						return
					if !child.local_data == null && !child.skill_role != null:
						Utils.removeSkillFormId(role_data,child.skill_role.id)#删除角色已装备的技能为空
						Utils.setSkillFormAll(child.skill_role.id,null)#设置背包中已经装备的技能为空
					Utils.addSkillFormRole(role_data,check_temp_ins.skill_role)
					reloadPratySKill()
					StorageData._save_storage()
	item_up_clear()

func item_up_clear():
	check_temp_ins = null
	get_parent().tempSKillIcon.texture = null
	get_parent().tempSKillIcon.visible = false

	#skill_tips_ins.showTips(skill_data["name"],skill_data["info"])

#人物穿戴装备点击绑定
func hero_equ_click(child):
	loadEquInfo(child.local_data)
#===================================
func _on_ClickTimer_timeout():
	if check_temp_ins != null:
		get_parent().tempSKillIcon.texture = load(check_temp_ins.local_data.image)
		get_parent().tempSKillIcon.visible = true
		if skill_tips_ins != null:
			skill_tips_ins.close()

#装备信息展示
func loadEquInfo(equ_data):
	if equ_data == null:
		return
	check_equ_data = equ_data
	$Equ_info.visible = true
	free_item($Equ_info/VBoxContainer.get_children())
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
	if equ_data["seal"].size()>0:
		var label = label_ui.instance()
		label.text = "\n刻印属性："
		$Equ_info/VBoxContainer.add_child(label)
	for attr_item in equ_data["seal"]:
		var label = label_ui.instance()
		label.text = EquUtils.get_attr_string(attr_item.keys()[0]) + " + %s" %attr_item.values()[0]
		$Equ_info/VBoxContainer.add_child(label)
	if equ_data.has("tz"):
		var label = label_ui.instance()
		label.text = "套装：%s [%s/8]" %[equ_data.tz.name,Utils.findEquTzSize(role_data,equ_data.tz)]
		label.set('custom_colors/font_outline_modulate', "#b766A5")
		$Equ_info/VBoxContainer.add_child(label)
	if equ_data["is_on"]:
		$Equ_info/btn_down.text = "卸下"
		$Equ_info/btn_des.visible = false
		$Equ_info/btn_des2.visible = false
	else:
		$Equ_info/btn_down.text = "穿戴"
		$Equ_info/btn_des.visible = true
		$Equ_info/btn_des2.visible = true

#装备按钮区域
#=========================
#穿戴装备
func setEqu2Role(type,equ_data):
	$Equ_info.visible = false
	equ_data.is_on = true
	role_data["equ"][type] = equ_data["id"]
	StorageData._save_storage()
	loadAllEqu()
	reLoadHeroEqu()
	loadHeroData()
	if equ_info != null:
		get_tree().call_group("equ_info","free")

#装备列表绑定点击
func equ_item_click(_ins):
	var equ_data = _ins.local_data
	if over_ins != null && is_instance_valid(over_ins):
		if equ_data.has("build_id"):		
			over_ins.addEqu(equ_data)
		else:
			ConstantsValue.showMessage("由于数据设计问题，1.0.2后更新打造的装备才可以融合!",5)
	else:
		loadEquInfo(equ_data)

#装备对比按钮
func _on_btn_des2_pressed():
	if check_equ_data != null:
		if !role_data.equ.has(check_equ_data.type):
			ConstantsValue.showMessage("对比部位没有穿戴装备！",2)
			return
		if role_data.equ[check_equ_data.type] == null:
			ConstantsValue.showMessage("对比部位没有穿戴装备！",2)
			return
		var ins = equ_info.instance()
		add_child(ins)
		ins.loadEquInfo(StorageData.get_player_equipment()[role_data.equ[check_equ_data.type]])

#批量丢弃装备
func _on_other_attr2_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		$Equ_info.visible = false
		add_child(discard_ui.instance())

#装备融合
func _on_other_over_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		over_ins = over_item.instance()
		add_child(over_ins)
		$Equ_info.visible = false

#卸下装备
var down_click = false
func _on_btn_down_pressed():
	if check_equ_data == null || down_click:
		return
	down_click = true
	if check_equ_data["is_on"]:
		check_equ_data.is_on = false
		role_data["equ"].erase(check_equ_data["type"])
		StorageData._save_storage()
		$Equ_info.visible = false
		ConstantsValue.showMessage("已卸下%s"%check_equ_data.name,1)
		check_equ_data = null
	else:
		if check_equ_data.lv > role_data["lv"]:
			ConstantsValue.showMessage("人物等级不足，无法穿戴！",2)
		else:
			var type = check_equ_data.type
			if role_data.equ.has(type) && StorageData.get_player_equipment().has(role_data.equ[type]) && StorageData.get_player_equipment()[role_data.equ[type]] != null:
				StorageData.get_player_equipment()[role_data.equ[type]].is_on = false
			setEqu2Role(type,check_equ_data)
			ConstantsValue.showMessage("已穿戴%s"%check_equ_data.name,1)
	loadAllEqu()
	reLoadHeroEqu()
	loadHeroData()
	down_click = false

#丢弃装备
func _on_btn_des_pressed():
	if check_equ_data != null:
		if equ_info != null:
			get_tree().call_group("equ_info","free")
		ConstantsValue.showMessage("已丢弃%s"%check_equ_data.name,1)
		$Equ_info.visible = false
		StorageData.get_player_equipment().erase(check_equ_data.id)
		loadAllEqu()
#=====================================================
#套装点击
func _on_btn_tz_pressed():
	var tz = preload("res://UI/ControlUI/TzBox.tscn").instance()
	if check_equ_data != null:
		ConstantsValue.showTzBox(check_equ_data,self)
#刻印点击
func _on_btn_seal_pressed():
	if check_equ_data != null:
		ConstantsValue.showSealBox(check_equ_data,self)

#刻印属性更新
func seal_choose():
	loadEquInfo(check_equ_data)
	loadHeroData()
	get_tree().call_group("player_role","reloadRoleAttr",role_data.rid)
#=========================

#公共方法
func reloadPratySKill():
	get_tree().call_group("player_role","loadRoleSkill")
	loadAllSkill()
	loadHeroSkill()
	StorageData._save_storage()

func free_item(array):
	for item in array:
		item.queue_free()
	array.clear()

func _on_PartyUI_visibility_changed():
	if ConstantsValue.const_choose_role_arrt != null:
		ConstantsValue.const_choose_role_arrt.visible = false
	if !visible:
		$PostionBox.visible = false

#位置点击更换===============================================
func _on_TextureRect2_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if !$PostionBox.visible:
			$PostionBox/AnimationPlayer.play("show")
		match role_position:
			0:
				$PostionBox/postion_0/position.text = Utils.getPositionWithIndex(1)
				$PostionBox/postion_1/position.text = Utils.getPositionWithIndex(2)
				$PostionBox/postion_2/position.text = Utils.getPositionWithIndex(-1)
			1:
				$PostionBox/postion_0/position.text = Utils.getPositionWithIndex(0)
				$PostionBox/postion_1/position.text = Utils.getPositionWithIndex(2)
				$PostionBox/postion_2/position.text = Utils.getPositionWithIndex(-1)
			2:
				$PostionBox/postion_0/position.text = Utils.getPositionWithIndex(0)
				$PostionBox/postion_1/position.text = Utils.getPositionWithIndex(1)
				$PostionBox/postion_2/position.text = Utils.getPositionWithIndex(-1)
			_:
				$PostionBox/postion_0/position.text = Utils.getPositionWithIndex(0)
				$PostionBox/postion_1/position.text = Utils.getPositionWithIndex(1)
				$PostionBox/postion_2/position.text = Utils.getPositionWithIndex(2)

#位置点击
func _on_postion_0_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		var index = Utils.getPositionWithName($PostionBox/postion_0/position.text)
		setRole2Position(index)

func _on_postion_1_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		var index = Utils.getPositionWithName($PostionBox/postion_1/position.text)
		setRole2Position(index)

func _on_postion_2_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		var index = Utils.getPositionWithName($PostionBox/postion_2/position.text)
		setRole2Position(index)

var is_changeing = false#正在切换位置
#切换冒险者位置
func setRole2Position(_index):
	if is_changeing:
		return
	is_changeing = true
	if _index != -1:
		if StorageData.get_player_state()["team_position"].has(role_data.rid):
			 StorageData.get_player_state()["team_position"][role_position] = null
		StorageData.get_player_state()["team_position"][_index] = role_data.rid
		ConstantsValue.showMessage("已切换到%s" %Utils.getPositionWithIndex(_index),1)
		get_tree().call_group("game_main","changeRolePosition",true)
	else:
		var size = 0
		for rid in StorageData.get_player_state()["team_position"]:
			if rid != null:
				size += 1
		if size > 1:
			StorageData.get_player_state()["team_position"][role_position] = null
			ConstantsValue.showMessage("冒险者已休战",1)
			get_tree().call_group("game_main","changeRolePosition",true)
		else:
			ConstantsValue.showMessage("至少需要一名冒险者在队伍中！",2)
	StorageData._save_storage()
	loadAllHero()
	showPosition()
	$PostionBox.visible = false
	is_changeing = false
#=====================================================

#其他属性面板
func _on_other_attr_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if role_data != null:
			ConstantsValue.showAttrBox(self,hero_attr)

#助战
func _on_spirit_pressed():
	pass # Replace with function body.
