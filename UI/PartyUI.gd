extends Control


onready var srcoll = $ScrollContainer

func _ready():
	visible = false
	var line = StyleBoxTexture.new()
	srcoll.get_h_scrollbar().set("custom_styles/scroll",line)
	
func partyChange(change):
	visible = change

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		partyChange(false)


func _on_ScrollContainer_scroll_started():
	print("asdasd")


func _on_ScrollContainer_scroll_ended():
	print("end")
