extends Control

func _ready():
	$PostionBox/AnimationPlayer.play("show")

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		queue_free()


func _on_postion_0_gui_input(event, extra_arg_0):
	if event is InputEventMouseButton and event.pressed:
		if Utils.removeEquWithQy(extra_arg_0) > 0:
			ConstantsValue.reloadAllEqu()
			queue_free()
		else:
			ConstantsValue.showMessage("该品质下没有装备！",2)
