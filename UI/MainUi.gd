extends Control


func _ready():
	visible = false

func showui():
	visible = true
	$AnimationPlayer.play("show")

func _on_map_pressed():
	if !get_parent().map_ui.visible:
		get_parent().map_ui.show_map()


func _on_chest_pressed():
	if !get_parent().bag_ui.visible:
		get_parent().bag_ui.bagChange(true)
