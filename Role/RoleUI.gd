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
