extends Control


func _ready():
	visible = false

func bagChange(change):
	visible = change

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		bagChange(false)
