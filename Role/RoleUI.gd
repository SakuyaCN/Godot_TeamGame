extends Control

onready var role_data #角色属性
onready var ui_name = $name
onready var attr_paint = $attr

func _ready():
	pass

func initRole():
	role_data = get_parent().role_data
	loadData()

func loadData():
	ui_name.text = role_data["nickname"]
	load_attr()

func load_attr():
	$attr/label_hp.text = str(role_data.attr.hp)
	$attr/label_atk.text = str(role_data.attr.atk)
	$attr/label_mtk.text = str(role_data.attr.mtk)
	$attr/label_def.text = str(role_data.attr.def)
	$attr/label_speed.text = str(role_data.attr.speed)
	$attr/label_crit.text = str(role_data.attr.crit)
	$attr/label_mdef.text = str(role_data.attr.mdef)
	$attr/label_lv.text = str(role_data.lv)

func _on_RoleUI_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
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
		if !get_parent().am_player.is_playing():
			get_parent().am_player.play("choose")
