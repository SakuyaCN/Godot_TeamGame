extends Control

func _ready():
	pass # Replace with function body.

func showTips(_name,_info):
	$ColorRect/NinePatchRect/Name.text = _name
	$ColorRect/NinePatchRect/Info.text = _info


func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		close()

func close():
	get_parent().skill_tips_ins = null
	queue_free()
