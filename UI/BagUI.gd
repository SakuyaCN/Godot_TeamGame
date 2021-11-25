extends Control

onready var invItem = preload("res://UI/ItemUI/invItem.tscn")

onready var grid = $NinePatchRect/GridContainer
onready var player = $AnimationPlayer

onready var glod = $gold

var dataInfo

func _ready():
	$Item.visible = false
	add_to_group("bag_ui")
	for data in 40:
		var ins = invItem.instance()
		ins.connect("pressed",self,"grid_child_pressed",[ins])
		grid.add_child(ins)
	visible = false
	bagInit()

func bagInit():
	var index = 0
	for data in 40:
		if StorageData.get_player_inventory().size() > index:
			grid.get_children()[index].setData(StorageData.get_player_inventory().keys()[index]
			,StorageData.get_player_inventory().values()[index])
		index+=1

func bagChange(change):
	visible = change
	if visible:
		glod.text = "拥有金币：%s" %StorageData.get_player_state()["gold"] 
		bagInit()

func grid_child_pressed(data):
	if data.inv_name != null:
		loadItem(data.inv_name)
		if !$Item.visible:
			$Item.visible = true
			player.play("item_show")

func loadItem(_name):
	dataInfo = LocalData.all_data["goods"][_name]
	$Item/Name.text = _name
	$Item/Info.text = dataInfo["info"]
	$Item/Lv.text = "等级：%s" %dataInfo["lv"]
	if dataInfo["useable"]:
		$Item/useable.visible = true
	else:
		$Item/useable.visible = false

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		bagChange(false)

func _on_BagUI_visibility_changed():
	if !visible:
		$Item.visible = false

#使用道具
func _on_Button_pressed():
	if Utils.is_lv_ok(dataInfo["lv"]):
		GoodsUtils.useGoods(self,dataInfo["name"],1)
	else:
		ConstantsValue.showMessage("至少需要一名队员达到%s级方可使用道具"%dataInfo["lv"],2)
