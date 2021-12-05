extends Control


onready var exp_box = preload("res://UI/ControlUI/BoxItem/ExpBox.tscn")

var exp_box_ins = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Button_pressed():
	if exp_box_ins == null:
		exp_box_ins = exp_box.instance()
		add_child(exp_box_ins)


func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		queue_free()
