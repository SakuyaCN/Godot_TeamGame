extends Control

onready var role_data #角色属性
onready var hero_attr :HeroAttrBean
onready var ui_name = $name
onready var attr_paint = $attr

func _ready():
	pass

func initRole():
	hero_attr = get_parent().hero_attr
	role_data = get_parent().role_data
	loadData()

func loadData():
	ui_name.text = role_data["nickname"]
	load_attr()

func load_attr():
	$attr/label_hp.text = str(hero_attr.hp)
	$attr/label_atk.text = str(hero_attr.atk)
	$attr/label_mtk.text = str(hero_attr.mtk)
	$attr/label_def.text = str(hero_attr.def)
	$attr/label_speed.text = str(hero_attr.speed)
	$attr/label_crit.text = str(hero_attr.crit)
	$attr/label_mdef.text = str(hero_attr.mdef)
	$attr/label_lv.text = str(role_data.lv)

func _on_RoleUI_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if get_parent().is_position:
			return
		if ConstantsValue.const_choose_role_arrt != null && ConstantsValue.const_choose_role_arrt.visible:
			if ConstantsValue.const_choose_role_arrt != attr_paint:
				ConstantsValue.const_choose_role_arrt.visible = false
				attr_paint.visible = true
				ConstantsValue.const_choose_role_arrt = attr_paint
			else:
				ConstantsValue.const_choose_role_arrt.visible = false
		else:
			attr_paint.visible = true
			ConstantsValue.const_choose_role_arrt = attr_paint

func _on_attr_visibility_changed():
	if attr_paint.visible:
		if attr_paint.global_position.x < 200:
			attr_paint.position.x += 40
		if !get_parent().am_player.is_playing():
			get_parent().am_player.play("choose")
