extends Control

onready var progress = $progress_hp
onready var progress_tv = $progress_hp/label_hp 

onready var setting_view = preload("res://UI/Setting.tscn")
onready var day_gif = preload("res://UI/GoodsDialog/DayGif.tscn")
onready var box_ui = preload("res://UI/ControlUI/BoxUI.tscn")
onready var level_1 = preload("res://UI/GameLevel/Leve_1.tscn")

onready var build_ui = preload("res://UI/ControlUI/BuildUI.tscn")

func _ready():
	visible = false
	#StorageData.AddGoodsNum([["荒漠金币",100]])
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
	get_parent().add_child(build_ui.instance())

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

#云端山脉
func _on_map2_pressed():
	if !Utils.is_lv_ok(30):
		ConstantsValue.showMessage("请至少一名冒险者达到30级再来挑战",2)
		return
	if StorageData.UseGoodsNum([["荒漠金币",1]]):
		ConstantsValue.ui_layer.change_scene("res://UI/GameLevel/Leve_1.tscn")
	else:
		ConstantsValue.showMessage("需要一枚【荒漠金币】,请前往炼金台中打造！",5)

func _on_update_pressed():
	if !StorageData.get_player_state().has("update_gif"):
		StorageData.get_player_state()["update_gif"] = []
	if StorageData.get_player_state()["update_gif"].has(ConstantsValue.version):
		ConstantsValue.showMessage("已经领取更新奖励！",2)
	else:
		StorageData.get_player_state()["update_gif"].append(ConstantsValue.version)
		StorageData.AddGoodsNum([
			["荒漠金币",5],
			["刻印碎片",200],
			["青岚铁矿",50],
			["秘银矿石",100]
		])

#广告奖励
func _on_ad_pressed():
	var ad = preload("res://UI/GoodsDialog/AdGif.tscn").instance()
	add_child(ad)
