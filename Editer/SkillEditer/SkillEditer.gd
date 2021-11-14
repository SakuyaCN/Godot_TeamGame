extends Control

var skill_data

func _ready():
	loadSkillData("res://Storage/SkillData.json")
	loadSkillUI()

func loadSkillData(_skill_path):
	var item_data_file = File.new()
	item_data_file.open(_skill_path,File.READ)
	skill_data = JSON.parse(item_data_file.get_as_text()).result
	item_data_file.close()
	if skill_data == null:
		skill_data = {}

func loadSkillUI():
	for item in skill_data:
		pass

func _on_add_pressed():
	$AddSkillDialog.popup()

#添加技能图片结果
func _on_FileDialog_file_selected(path):
	$AddSkillDialog/Panel/add_img.icon = load(path)

func _on_AddSkillDialog_confirmed():
	print($AddSkillDialog/Panel/SpinBox.value)

#富文本预览
func _on_Button_pressed():
	$AddSkillDialog/Panel/rich.clear()
	$AddSkillDialog/Panel/rich.append_bbcode($AddSkillDialog/Panel/TextEdit2.text)
	$AddSkillDialog/Panel/rich.visible = !$AddSkillDialog/Panel/rich.visible

#添加技能图片
func _on_add_img_pressed():
	$FileDialog.popup()
