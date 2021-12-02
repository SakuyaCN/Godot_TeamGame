extends Control

onready var label_ui = preload("res://UI/ControlUI/LabelItemUI.tscn")

func _ready():
	add_to_group("equ_info")

func loadEquInfo(equ_data):
	if equ_data == null:
		return
	$Equ_info.visible = true
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

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		queue_free()
