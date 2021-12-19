extends Control

onready var invItem = preload("res://UI/ItemUI/BoxinvItem.tscn")
onready var spinvItem = preload("res://UI/ItemUI/spiritItem.tscn")

func _ready():
	pass # Replace with function body.

func setGoods(array):
	for data in array:
		var ins = invItem.instance()
		$bg/GridContainer.add_child(ins)
		ins.setData(data[0],data[1])

func add_spirit(_data):
	var node = spinvItem.instance()
	$bg/GridContainer.add_child(node)
	node.setSeal(_data)

func _on_bg_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		queue_free()
