extends Button

var _data = null
var gname = ""

func setData(_name,num):
	gname = _name
	_data = LocalData.all_data["goods"][_name]
	$TextureRect.texture = load(_data.image)
	$Label.text = "*%s" %num


func _on_BuildInfoNeedItem_button_down():
	if _data != null:
		ConstantsValue.ui_layer.showTips(self,gname+"："+_data.info)

func _on_BuildInfoNeedItem_button_up():
	ConstantsValue.ui_layer.closeTips()

func _on_BuildInfoNeedItem_tree_exited():
	_data = null
