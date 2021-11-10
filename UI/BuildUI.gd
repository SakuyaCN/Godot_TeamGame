extends Control

var buildData:Dictionary
onready var build_item_label = preload("res://UI/ItemUI/BuidlItemLabel.tscn")

func _ready():
	var line = StyleBoxTexture.new()
	$NinePatchRect/ScrollContainer.get_v_scrollbar().set("custom_styles/scroll",line)
	buildData = LocalData.build_data
	visible = false
	loadBuildData()

func loadBuildData():
	for item in buildData["build_type"]:
		var label_ins = build_item_label.instance()
		label_ins.text = item
		$NinePatchRect/ScrollContainer/VBoxContainer.add_child(label_ins)

func buildChange(change):
	visible = change

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		buildChange(false)
