extends Control

onready var invItem = preload("res://UI/ItemUI/invItem.tscn")

onready var grid = $NinePatchRect/GridContainer
onready var player = $AnimationPlayer

func _ready():
	for data in 40:
		var ins = invItem.instance()
		grid.add_child(ins)
	visible = false
	bagInit()

func bagInit():
	var index = 0
	for data in StorageData.get_player_inventory():
		grid.get_children()[index].setData(data,StorageData.get_player_inventory()[data])
		grid.get_children()[index].connect("pressed",self,"grid_child_pressed",[data])
		index+=1

func bagChange(change):
	visible = change

func grid_child_pressed(data):
	loadItem(data)
	if !$Item.visible:
		$Item.visible = true
		player.play("item_show")

func loadItem(_name):
	var dataInfo = LocalData.all_data["goods"][_name]
	$Item/Name.text = _name
	$Item/Info.text = dataInfo["info"]
	$Item/Lv.text = "等级：%s" %dataInfo["lv"]

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		bagChange(false)


func _on_BagUI_visibility_changed():
	if !visible:
		$Item.visible = false
