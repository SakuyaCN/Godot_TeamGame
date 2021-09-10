extends Control

onready var parent = get_parent()

func _ready():
	visible = true

func _on_Button2_pressed():
	get_tree().quit(0)

func _on_Button_pressed():
	if StorageData.storage_data["player_state"].empty():
		parent.create_ui.show()
	else:
		parent.get_parent().get_parent().start_game()
	hide()
