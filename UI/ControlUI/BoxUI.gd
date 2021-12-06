extends Control


onready var exp_box = preload("res://UI/ControlUI/BoxItem/ExpBox.tscn")
onready var seal_box = preload("res://UI/ControlUI/BoxItem/SealBox.tscn")

var exp_box_ins = null
var seal_box_ins = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Button_pressed():
	removeAll()
	if exp_box_ins == null:
		exp_box_ins = exp_box.instance()
	$ChildUI.add_child(exp_box_ins)

func removeAll():
	for item in $ChildUI.get_children():
		get_tree().queue_delete(item)
	exp_box_ins = null
	seal_box_ins = null

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().queue_delete(self)

func _on_Button2_pressed():
	removeAll()
	if seal_box_ins == null:
		seal_box_ins = seal_box.instance()
	$ChildUI.add_child(seal_box_ins)
