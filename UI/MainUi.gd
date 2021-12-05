extends Control

onready var progress = $progress_hp
onready var progress_tv = $progress_hp/label_hp 

onready var setting_view = preload("res://UI/Setting.tscn")
onready var day_gif = preload("res://UI/GoodsDialog/DayGif.tscn")
onready var box_ui = preload("res://UI/ControlUI/BoxUI.tscn")

func _ready():
	visible = false
	#setTitle(StorageData.storage_data["player_state"]["now_map"]+1)

func showui():
	visible = true
	$AnimationPlayer.play("show")

func _on_map_pressed():
	if !get_parent().map_ui.visible:
		get_parent().map_ui.show_map()

func _on_chest_pressed():
	if !get_parent().bag_ui.visible:
		get_parent().bag_ui.bagChange(true)

func _on_party_pressed():
	if !get_parent().party_ui.visible:
		get_parent().party_ui.partyChange(true)

func _on_build_pressed():
	if !get_parent().build_ui.visible:
		get_parent().build_ui.buildChange(true)

func setTitle(_lv):
	$title/Label.text = "当前关卡：%s" %_lv
	$NinePatchRect/Label2.text = Utils.getMapNameFormIndex(StorageData.storage_data["player_state"]["map_index"])

#设置
func _on_setting_pressed():
	get_parent().add_child(setting_view.instance())

#每日奖励
func _on_sign_pressed():
	get_parent().add_child(day_gif.instance())

#百宝箱
func _on_box_pressed():
	get_parent().add_child(box_ui.instance())
