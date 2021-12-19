extends Control

var role_data = null
onready var spinvItem = preload("res://UI/ItemUI/spiritItem.tscn")


func set_role(_role_data):
	role_data = _role_data
	reload()

func reload():
	for item in $NinePatchRect/ScrollContainer/GridContainer.get_children():
		item.queue_free()
	for item in StorageData.get_all_spirit():
		if StorageData.get_all_spirit().has(item) && StorageData.get_all_spirit()[item] != null:
			var ins = spinvItem.instance()
			$NinePatchRect/ScrollContainer/GridContainer.add_child(ins)
			ins.setSeal(StorageData.get_all_spirit()[item])
			ins.connect("pressed",self,"item_click",[StorageData.get_all_spirit()[item]])
			ins._label.visible = false

func item_click(_data):
	$Item/RichTextLabel.clear()
	$Item/RichTextLabel.append_bbcode("【Lv.%s】%s\n" %[_data.lv,_data.name])
	$Item/RichTextLabel.append_bbcode("成长属性：\n")
	for attr in _data.base_attr:
		$Item/RichTextLabel.append_bbcode("%s : %s\n" %[EquUtils.get_attr_string(attr),_data.base_attr[attr] * _data.lv])

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		queue_free()
