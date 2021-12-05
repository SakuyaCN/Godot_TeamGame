extends Control

var role_data = null
var role_skill = null
func _ready():
	pass # Replace with function body.

func showTips(_role_skill,_name,_info,_skill_lv,_role_data = null):
	role_skill = _role_skill
	role_data = _role_data
	$ColorRect/NinePatchRect/Name.text = _name
	$ColorRect/NinePatchRect/Info.text = _info
	$ColorRect/NinePatchRect/lv.text = "等级：%d" %_skill_lv
	if role_data != null:
		$Button.text = "卸下"
	else:
		$Button.text = "分解"

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		close()

func close():
	get_parent().skill_tips_ins = null
	queue_free()

var pass_click = 0

func _on_Button_pressed():
	if role_skill != null:
		if role_data != null:
			Utils.removeSkillFormRole(role_data,role_skill.id)
			Utils.setSkillFormAll(role_skill.id,null)
			get_tree().call_group("PartyUI","reloadPratySKill")
			close()
		else:
			pass_click += 1
			if pass_click == 2:
				Utils.removeSkillFormAll(role_skill.id)
				get_tree().call_group("PartyUI","reloadPratySKill")
				close()
			else:
				ConstantsValue.showMessage("再按一次丢弃技能",1)
			yield(get_tree().create_timer(0.7),"timeout")
			pass_click = 0
