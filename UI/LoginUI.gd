extends Control

onready var parent = get_parent()

func _ready():
	if !ConstantsValue._is_start:
		visible = true

func _on_Button2_pressed():
	get_tree().quit(0)

func _on_Button_pressed():
	if StorageData.storage_data["player_state"].empty():
		parent.create_ui.show()
	else:
		parent.get_parent().get_parent().start_game()
	hide()

#创意编辑
func _on_Button3_pressed():
	#get_tree().change_scene("res://Editer/SkillEditer/SkillEditer.tscn")
	$NinePatchRect.visible = true

func _on_NinePatchRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		$NinePatchRect.visible = false


func _on_NinePatchRect2_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		$NinePatchRect2.visible = false
